import 'dart:io';
//import 'package:echat/nationalidverification/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputPhoto extends StatefulWidget {
  const InputPhoto({super.key});

  @override
  State<InputPhoto> createState() => _InputPhotoState();
}

class _InputPhotoState extends State<InputPhoto> {
  File? idPhoto;
  File? selfiePhoto;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _pickPhoto(bool isIdPhoto) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 90,
    );
    
    if (picked != null) {
      setState(() {
        if (isIdPhoto) {
          idPhoto = File(picked.path);
        } else {
          selfiePhoto = File(picked.path);
        }
      });
    }
  }

  void _continue() async {
    if (idPhoto == null || selfiePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please take both photos first")),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

  
  }

  void _showResultDialog(bool isSimilar, double similarityScore, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSimilar ? "✅ Verification Successful" : "❌ Verification Failed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Similarity Score: ${(similarityScore * 100).toStringAsFixed(1)}%"),
            const SizedBox(height: 10),
            Text("Status: ${isSimilar ? 'Faces match' : 'Faces do not match'}"),
            const SizedBox(height: 10),
            Text("Message: $message"),
          ],
        ),
        actions: [
          if (!isSimilar)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Retry"),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isSimilar) {
                // Proceed to next screen
                // Navigator.push(context, MaterialPageRoute(builder: (_) => NextScreen()));
              }
            },
            child: Text(isSimilar ? "Continue" : "Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Verification"),
        centerTitle: true,
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // National ID photo section
                  _buildPhotoSection(
                    title: "National ID Photo",
                    photo: idPhoto,
                    isIdPhoto: true,
                    color: Colors.blue,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Selfie photo section
                  _buildPhotoSection(
                    title: "Selfie Photo",
                    photo: selfiePhoto,
                    isIdPhoto: false,
                    color: Colors.green,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Continue button
                  ElevatedButton.icon(
                    onPressed: _continue,
                    icon: const Icon(Icons.person,color: Colors.blue,),
                    label: const Text("Verify The ID"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPhotoSection({
    required String title,
    required File? photo,
    required bool isIdPhoto,
    required Color color,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () => _pickPhoto(isIdPhoto),
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color, width: 2),
            ),
            child: photo == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isIdPhoto ? Icons.credit_card : Icons.face,
                        size: 60,
                        color: color,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Tap to take photo",
                        style: TextStyle(color: color, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(photo, fit: BoxFit.cover),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}