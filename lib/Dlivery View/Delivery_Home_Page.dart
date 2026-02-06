
import 'package:linkedfarm/Dlivery%20View/livelocationtrack.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedfarm/User%20Credential/log_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery_Home_Page extends StatefulWidget {
  const Delivery_Home_Page({super.key});

  @override
  State<Delivery_Home_Page> createState() => _Delivery_Home_PageState();
}

class _Delivery_Home_PageState extends State<Delivery_Home_Page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DeliveryLocationUpdater _locationUpdater = DeliveryLocationUpdater();
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _checkOnlineStatus();
  }

  void _checkOnlineStatus() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    
    final doc = await FirebaseFirestore.instance.collection("delivery_locations").doc(uid).get();
    if (doc.exists) {
      setState(() {
        _isOnline = doc.data()?['isOnline'] ?? false;
      });
      if (_isOnline) {
        _locationUpdater.startSendingLocation();
      }
    }
  }

  void _toggleOnlineStatus(bool value) async {
    setState(() {
      _isOnline = value;
    });

    if (value) {
      await _locationUpdater.startSendingLocation();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are now ONLINE. Farmers can see you.")),
      );
    } else {
      await _locationUpdater.stopLocationTracking();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are now OFFLINE.")),
      );
    }
  }

  void _logout() async {
    await _locationUpdater.stopLocationTracking();
    await _auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LogInPage(onTap: null)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("LinkedFarm Delivery"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _isOnline ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isOnline ? Colors.green[700] : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isOnline,
                  onChanged: _toggleOnlineStatus,
                  activeColor: Colors.orange[700],
                  activeTrackColor: Colors.orange[100],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Orders / Tasks Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Jobs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_shipping_outlined, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "No Delivery Requests Yet",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Stay online to receive orders nearby.",
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
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