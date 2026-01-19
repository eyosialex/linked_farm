import 'package:flutter/material.dart';

class Mytextfield extends StatefulWidget {
  final TextEditingController con;
  final String HintText;
  final bool valid;
  const Mytextfield({
    super.key,
    required this.con,
    required this.HintText,
    required this.valid,
  });
  @override
  State<Mytextfield> createState() => _MytextfieldState();
}

class _MytextfieldState extends State<Mytextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.con,
        obscureText: widget.valid,
        decoration: InputDecoration(
          hintText: widget.HintText,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
