import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  // Your Cloudinary credentials
  static const String cloudName = 'dgp9dusw5';
  static const String apiKey = '773151611459787';
  static const String uploadPreset = 'chattphoto'; // Your upload preset

  // Upload single image using HTTP
  Future<String?> uploadImage(File imageFile, {String folder = 'agricultural_items'}) async {
    try {
   //   print('🚀 Starting Cloudinary upload for: ${imageFile.path}');
      
      // Check if file exists
      if (!await imageFile.exists()) {
      //  print('❌ File does not exist');
        return null;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      );
      
      // Add upload parameters
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      
      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

     // print('📤 Sending request to Cloudinary...');
      
      // Send the request with timeout
      var response = await request.send().timeout(const Duration(seconds: 30));
      
      // Get response body
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      
      //print('📥 Cloudinary Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        String imageUrl = jsonResponse['secure_url'];
       // print('✅ Image uploaded successfully!');
        //print('🔗 URL: $imageUrl');
        return imageUrl;
      } else {
        //print('❌ Upload failed with status: ${response.statusCode}');
        //print('Error details: ${jsonResponse['error']}');
        return null;
      }
    } catch (e) {
      //print('❌ Cloudinary upload error: $e');
      return null;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
    List<String> imageUrls = [];
    
    print('🔄 Starting batch upload of ${imageFiles.length} images...');
    
    for (int i = 0; i < imageFiles.length; i++) {
      print('📸 Uploading image ${i + 1}/${imageFiles.length}');
      
      String? imageUrl = await uploadImage(imageFiles[i]);
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
        print('✅ Image ${i + 1} uploaded successfully');
      } else {
        print('❌ Failed to upload image ${i + 1}');
      }
      
      // Small delay between uploads to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    print('🎉 Batch upload completed: ${imageUrls.length}/${imageFiles.length} successful');
    return imageUrls;
  }

  // Test method to verify Cloudinary connection
  Future<bool> testConnection() async {
    try {
      print('🔍 Testing Cloudinary connection...');
      print('Cloud Name: $cloudName');
      print('Upload Preset: $uploadPreset');
      
      // Simple test - if we can reach the endpoint
      var testResponse = await http.get(
        Uri.parse('https://res.cloudinary.com/$cloudName/image/upload/sample.jpg'),
      ).timeout(const Duration(seconds: 10));
      
      if (testResponse.statusCode == 200 || testResponse.statusCode == 404) {
        // 404 is expected for non-existent image, but means endpoint is reachable
        print('✅ Cloudinary connection test passed!');
        return true;
      } else {
        print('❌ Cloudinary connection test failed: ${testResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Connection test error: $e');
      return false;
    }
  }
}