import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryLocationUpdater {
  final Location _location = Location();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> startSendingLocation() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;  
      
      // 1️⃣ Check GPS service
      serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print("❌ Location service disabled");
          return;
        }
      }
      
      // 2️⃣ Check permission
      permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print("❌ Location permission denied");
          return;
        }
      }  
      
      print("✅ Location permissions granted, starting tracking...");
      
      // 3️⃣ Start listening to location changes
      _location.onLocationChanged.listen((loc) async {
        if (loc.latitude == null || loc.longitude == null) {
          print("⚠️ Invalid location data received");
          return;
        }
        
        final uid = FirebaseAuth.instance.currentUser!.uid;
        try {
          await _firestore.collection("delivery_locations").doc(uid).set({
            "latitude": loc.latitude,
            "longitude": loc.longitude,
            "updatedAt": FieldValue.serverTimestamp(),
            "isOnline": true,
          });
          print("📍 Location updated: ${loc.latitude}, ${loc.longitude}");
        } catch (e) {
          print("❌ Error updating location: $e");
        }
      }, onError: (error) {
        print("❌ Location listener error: $error");
      });
      
    } catch (e) {
      print("❌ Error in startSendingLocation: $e");
    }
  }

  Future<void> stopLocationTracking() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await _firestore.collection("delivery_locations").doc(uid).set({
        "isOnline": false,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("🛑 Location tracking stopped");
    } catch (e) {
      print("❌ Error stopping location tracking: $e");
    }
  }
}