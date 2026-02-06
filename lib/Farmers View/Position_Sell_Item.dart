import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:linkedfarm/l10n/app_localizations.dart';

class MapTestScreen extends StatefulWidget {
  final Function(String, String, String) onLocationSelected;

  const MapTestScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _MapTestScreenState createState() => _MapTestScreenState();
}

class _MapTestScreenState extends State<MapTestScreen> {
  GoogleMapController? mapController;
  LatLng _center = const LatLng(9.03, 38.74); // Default to Addis Ababa
  String? selectedAddress;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isMoving = false;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    // Fetch initial address for default location
    _getAddressFromLatLng(_center);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> parts = [];
        if (place.subLocality != null && place.subLocality!.isNotEmpty) parts.add(place.subLocality!);
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) parts.add(place.thoroughfare!);
        if (place.locality != null && place.locality!.isNotEmpty) parts.add(place.locality!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) parts.add(place.administrativeArea!);

        setState(() {
          selectedAddress = parts.join(', ');
          if (parts.isEmpty) {
             selectedAddress = "Lat: ${latLng.latitude.toStringAsFixed(4)}, Lng: ${latLng.longitude.toStringAsFixed(4)}";
          }
        });
      }
    } catch (e) {
      setState(() {
         selectedAddress = "Lat: ${latLng.latitude.toStringAsFixed(4)}, Lng: ${latLng.longitude.toStringAsFixed(4)}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        Location loc = locations[0];
        LatLng newPos = LatLng(loc.latitude, loc.longitude);
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPos, 16));
      } else {
        _showSnackBar(AppLocalizations.of(context)!.locationNotFound);
      }
    } catch (e) {
      if (e.toString().contains("IO_ERROR") || e.toString().contains("DEADLINE_EXCEEDED")) {
         _showSnackBar(AppLocalizations.of(context)!.networkError);
      } else {
         _showSnackBar(AppLocalizations.of(context)!.unableToFindLocation);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
    if (!_isMoving) {
      setState(() {
        _isMoving = true;
      });
    }
  }

  void _onCameraIdle() {
    setState(() {
      _isMoving = false;
    });
    _getAddressFromLatLng(_center);
  }

  void _confirmLocation() {
    widget.onLocationSelected(
      _center.latitude.toStringAsFixed(6),
      _center.longitude.toStringAsFixed(6),
      selectedAddress ?? AppLocalizations.of(context)!.unknownLocation,
    );
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
            mapType: _currentMapType,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),

          // Center Pin
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35), // Adjust for pin tip
              child: Icon(
                Icons.location_on,
                size: 45,
                color: Colors.red,
              ),
            ),
          ),

          // Floating Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchLocationHint,
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _searchLocation(),
                    ),
                  ),
                  if (_isLoading)
                     const Padding(
                       padding: EdgeInsets.only(right: 16),
                       child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                     )
                  else
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchLocation,
                    ),
                ],
              ),
            ),
          ),

          // Map Type Toggle
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 80,
            child: FloatingActionButton.small(
              heroTag: "mapType",
              onPressed: _toggleMapType,
              backgroundColor: Colors.white,
              child: Icon(Icons.layers, color: Colors.black87),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
              ),
               child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                     AppLocalizations.of(context)!.selectLocationTitle,
                     style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       const Icon(Icons.place, color: Colors.red, size: 24),
                       const SizedBox(width: 12),
                        Expanded(
                          child: _isMoving
                              ? Text(AppLocalizations.of(context)!.draggingStatus, style: const TextStyle(fontSize: 16, color: Colors.grey))
                              : Text(
                                  selectedAddress ?? AppLocalizations.of(context)!.fetchingStatus,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                     ],
                   ),
                   const SizedBox(height: 20),
                   SizedBox(
                     width: double.infinity,
                     child: ElevatedButton(
                       onPressed: (_isLoading || _isMoving) ? null : _confirmLocation,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Theme.of(context).colorScheme.primary,
                         foregroundColor: Colors.white,
                         padding: const EdgeInsets.symmetric(vertical: 16),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                       ),
                       child: Text(AppLocalizations.of(context)!.confirmLocationButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}