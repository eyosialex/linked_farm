import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationPage extends StatefulWidget {
  final String driverId;
  
  LiveLocationPage({required this.driverId});
  
  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  GoogleMapController? mapController;
  LatLng? currentPos;
  Map<String, dynamic>? driverDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDriverDetails();
    listenToDriverLocation();
  }

  void _loadDriverDetails() async {
    try {
      final driverDoc = await FirebaseFirestore.instance
          .collection("Usersstore")
          .doc(widget.driverId)
          .get();
          
      if (driverDoc.exists) {
        setState(() {
          driverDetails = driverDoc.data()!;
        });
      }
    } catch (e) {
      print("Error loading driver details: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // LISTEN TO FIRESTORE LIVE UPDATES
  void listenToDriverLocation() {
    FirebaseFirestore.instance
        .collection("delivery_locations")
        .doc(widget.driverId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        print("No location data found for driver");
        return;
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      if (data["latitude"] == null || data["longitude"] == null) {
        print("Invalid location data: $data");
        return;
      }
      
      setState(() {
        currentPos = LatLng(data["latitude"]!, data["longitude"]!);
        _isLoading = false;
      });
      
      // Move map to new location
      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentPos!),
      );
    }, onError: (error) {
      print("Error listening to location: $error");
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driverDetails?["fullName"] ?? "Driver Location"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading driver information..."),
                ],
              ),
            )
          : Column(
              children: [
                // Driver Info Card
                if (driverDetails != null)
                  Card(
                    margin: EdgeInsets.all(12),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driverDetails!["fullName"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text("Vehicle: ${driverDetails!["cartype"] ?? "Unknown"}"),
                                SizedBox(height: 4),
                                Text(
                                  "Status: ${currentPos != null ? "Live Tracking" : "Waiting for location"}",
                                  style: TextStyle(
                                    color: currentPos != null ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Map
                Expanded(
                  child: currentPos == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_off, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text("Driver location not available"),
                              SizedBox(height: 8),
                              Text(
                                "The driver may have turned off location sharing",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : GoogleMap(
                          onMapCreated: (controller) => mapController = controller,
                          initialCameraPosition: CameraPosition(
                            target: currentPos!,
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("driver"),
                              position: currentPos!,
                              infoWindow: InfoWindow(
                                title: driverDetails?["fullName"] ?? "Driver",
                                snippet: "Live Location - ${driverDetails?["cartype"] ?? "Vehicle"}",
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            ),
                          },
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                        ),
                ),
              ],
            ),
    );
  }
}