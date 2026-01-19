import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
class LocationService {
  final Location _location = Location();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // get request permission 
  Future<bool> requestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }
  // Save location to Firestore
  Future<void> updateLocationToFirestore(String userId, LocationData loc) async {
    await _firestore.collection("live_locations").doc(userId).set({
      "lat": loc.latitude,
      "lng": loc.longitude,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }
  
  // Get current location
  Future<LocationData?> getLocations() async {
    bool ok = await requestPermission();
    if (!ok) return null;
    return await _location.getLocation();
  }
// Listen for real-time location
  Stream<LocationData> onLocationChanged() {
    return _location.onLocationChanged;
  }
}
