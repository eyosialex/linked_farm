import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Dlivery%20View/dlivery_location_tracker.dart';
import 'package:echat/Dlivery%20View/livelocationtrack.dart';
import 'package:flutter/material.dart';

class availabledriverylist extends StatefulWidget {
  @override
  State<availabledriverylist> createState() => _availabledriverylistState();
}

class _availabledriverylistState extends State<availabledriverylist> {
  
  // Method to check if driver is online and get location
  Future<Map<String, dynamic>?> _getDriverLocationStatus(String driverId) async {
    try {
      final locationDoc = await FirebaseFirestore.instance
          .collection("delivery_locations")
          .doc(driverId)
          .get();
          
      if (locationDoc.exists) {
        final data = locationDoc.data()!;
        return {
          'isOnline': data['isOnline'] ?? false,
          'latitude': data['latitude'],
          'longitude': data['longitude'],
          'lastUpdate': data['updatedAt'],
        };
      }
      return null;
    } catch (e) {
      print("Error getting driver location: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Delivery Drivers"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Usersstore")
            .where("userType", isEqualTo: "delivery")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No delivery drivers available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Drivers will appear here when they register",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showBecomeDriverDialog(context);
                    },
                    icon: Icon(Icons.local_shipping),
                    label: Text("Become a Delivery Driver"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final drivers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              final driverData = driver.data() as Map<String, dynamic>;

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getDriverLocationStatus(driver.id),
                builder: (context, locationSnapshot) {
                  final isOnline = locationSnapshot.data?['isOnline'] ?? false;
                  final hasLocation = locationSnapshot.data?['latitude'] != null;
                  
                  return InkWell(
                    onTap: isOnline && hasLocation
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LiveLocationPage(driverId: driver.id),
                              ),
                            );
                          }
                        : null,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Online Status Indicator
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: isOnline ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: isOnline ? Colors.blueAccent : Colors.grey,
                              child: Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                            SizedBox(width: 12),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driverData["fullName"] ?? "Unknown Driver",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Vehicle: ${driverData["cartype"] ?? "Unknown"}",
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "License: ${driverData["deriving licence"] ?? "Not provided"}",
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: isOnline ? Colors.green : Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        isOnline ? "Online - Available" : "Offline",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isOnline ? Colors.green : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            Icon(
                              Icons.location_pin,
                              color: isOnline && hasLocation ? Colors.redAccent : Colors.grey,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      
      // Add button to become a delivery driver
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showBecomeDriverDialog(context);
        },
        icon: Icon(Icons.local_shipping),
        label: Text("Become Driver"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBecomeDriverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Become a Delivery Driver"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("To start earning as a delivery driver:"),
            SizedBox(height: 10),
            Text("• You need a valid driver's license"),
            Text("• A reliable vehicle"),
            Text("• Smartphone with GPS"),
            SizedBox(height: 10),
            Text("Contact support to complete your registration."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showContactSupportDialog(context);
            },
            child: Text("Contact Support"),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Contact Support"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: support@agrilead.com"),
            SizedBox(height: 8),
            Text("Phone: +251-XXX-XXXX"),
            SizedBox(height: 8),
            Text("We'll help you complete your driver registration."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}