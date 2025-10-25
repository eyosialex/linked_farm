import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Place extends StatefulWidget {
  final double latitude,longitude;
   Place({super.key,required this.latitude,required this.longitude});
  @override
  State<Place> createState() => _PlaceState();
}
class _PlaceState extends State<Place> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(widget.latitude,widget.longitude))),
    );
  }
}