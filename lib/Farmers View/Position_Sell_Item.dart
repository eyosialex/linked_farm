import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapTestScreen extends StatefulWidget {
  final Function(String, String) onLocationSelected;

  const MapTestScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _MapTestScreenState createState() => _MapTestScreenState();
}

class _MapTestScreenState extends State<MapTestScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  LatLng _center = const LatLng(9.03, 38.74);
  LatLng? selectedLocation;
  bool _isSelecting = false;
  double _mapZoom = 12.0;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _isSelecting = true;
      selectedLocation = latLng;
      markers.clear();
      circles.clear();

      markers.add(
        Marker(
          markerId: const MarkerId("selectedLocation"),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: "Selected Location",
            snippet: "Lat: ${latLng.latitude.toStringAsFixed(6)}, Lng: ${latLng.longitude.toStringAsFixed(6)}",
          ),
        ),
      );

      circles.add(
        Circle(
          circleId: const CircleId("selectionCircle"),
          center: latLng,
          radius: 100,
          fillColor: Colors.red.withOpacity(0.2),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );
    });
  }

  void _clearSelection() {
    setState(() {
      selectedLocation = null;
      markers.clear();
      circles.clear();
      _isSelecting = false;
    });
  }

  void _confirmLocation() {
    if (selectedLocation != null) {
      widget.onLocationSelected(
        selectedLocation!.latitude.toStringAsFixed(6),
        selectedLocation!.longitude.toStringAsFixed(6),
      );
      Navigator.pop(context);
    } else {
      _showSnackBar("Please select a location first");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: _mapZoom),
            markers: markers,
            circles: circles,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onTap: _onTap,
            onCameraMove: (CameraPosition position) {
              _mapZoom = position.zoom;
            },
          ),

          if (_isSelecting && selectedLocation != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_pin, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "Location Selected",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: _clearSelection,
                            tooltip: "Clear selection",
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Latitude: ${selectedLocation!.latitude.toStringAsFixed(6)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Longitude: ${selectedLocation!.longitude.toStringAsFixed(6)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _clearSelection,
                              child: const Text("Clear"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _confirmLocation,
                              child: const Text("Use This Location"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Tap anywhere on the map to select a location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}