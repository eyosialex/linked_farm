import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Farmers%20View/Cloudnary_Store.dart';
import 'package:echat/Farmers%20View/FireStore_Config.dart';
import 'package:echat/Farmers%20View/Sell_Item_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'Position_Sell_Item.dart';
class SellItem extends StatefulWidget {
  final AgriculturalItem? productToEdit;

  const SellItem({super.key, this.productToEdit});

  @override
  State<SellItem> createState() => _SellItemState();
}
class _SellItemState extends State<SellItem> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subcategoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  // Variables
  String _selectedCategory = '';
  String _selectedCondition = 'Fresh';
  String _selectedUnit = 'kg';
  DateTime? _availableFrom;
  bool _deliveryAvailable = false;
  List<File> _selectedImages = [];
  List<String> _existingImageUrls = [];
  List<String> _tags = [];
  bool _isUploading = false;
  Map<String, double>? _selectedLocation;
  
  // Services
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Product categories
  final List<String> _categories = [
    'Cereals', 'Pulses', 'Vegetables', 'Fruits', 'Spices',
    'Coffee', 'Oil Seeds', 'Tubers', 'Livestock', 'Others'
  ];

  final List<String> _conditions = ['Fresh', 'Dry', 'Organic', 'Processed', 'Frozen'];
  final List<String> _units = ['kg', 'quintal', 'ton', 'sack', 'piece', 'liter'];

  @override
  void initState() {
    super.initState();
    _availableFrom = DateTime.now();
    if (widget.productToEdit != null) {
      _loadProductData();
    } else {
      _loadCurrentUserInfo();
    }
  }

  void _loadProductData() {
    final product = widget.productToEdit!;
    _nameController.text = product.name;
    _selectedCategory = _categories.contains(product.category) ? product.category : '';
    _subcategoryController.text = product.subcategory ?? '';
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    _selectedUnit = _units.contains(product.unit) ? product.unit : _units.first;
    _selectedCondition = _conditions.contains(product.condition) ? product.condition : _conditions.first;
    _existingImageUrls = List.from(product.imageUrls ?? []);
    
    if (product.location != null) {
      _selectedLocation = product.location;
      locationController.text = "Lat: ${product.location!['lat']}, Lng: ${product.location!['lng']}";
    }
    
    _sellerNameController.text = product.sellerName;
    _contactInfoController.text = product.contactInfo;
    _availableFrom = product.availableFrom;
    _deliveryAvailable = product.deliveryAvailable;
    _tags = List.from(product.tags ?? []);
    if (product.tags != null) {
      _tagsController.text = ""; 
    }
  }

  void _loadCurrentUserInfo() {
    final user = _auth.currentUser;
    if (user != null) {
      // Pre-fill seller name with user's display name if available
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        _sellerNameController.text = user.displayName!;
      }
      
      // Pre-fill contact info with user's email
      if (user.email != null) {
        _contactInfoController.text = user.email!;
      }
    }
  }

  // Image Picker Methods
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
        _showSnackBar("Photo added successfully");
      }
    } catch (e) {
      _showSnackBar("Error taking photo: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
        _showSnackBar("${pickedFiles.length} photos added");
      }
    } catch (e) {
      _showSnackBar("Error selecting images: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _showSnackBar("Photo removed");
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
    _showSnackBar("Photo removed");
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Photos"),
        content: const Text("Choose image source"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromCamera();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text("Camera"),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text("Gallery"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onLocationSelected(String latitude, String longitude) {
    setState(() {
      _selectedLocation = {
        'lat': double.parse(latitude),
        'lng': double.parse(longitude),
      };
      locationController.text = "Lat: $latitude, Lng: $longitude"; 
    });
    _showSnackBar("Location selected successfully");
  }

  void _addTag() {
    if (_tagsController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagsController.text.trim());
        _tagsController.clear();
      });
    }
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _availableFrom ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _availableFrom = pickedDate;
        });
      }
    });
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty) {
      _showSnackBar("Please enter product name");
      return false;
    }
    if (_selectedCategory.isEmpty) {
      _showSnackBar("Please select a category");
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      _showSnackBar("Please enter product description");
      return false;
    }
    if (_priceController.text.isEmpty || double.tryParse(_priceController.text) == null) {
      _showSnackBar("Please enter a valid price");
      return false;
    }
    if (_quantityController.text.isEmpty || int.tryParse(_quantityController.text) == null) {
      _showSnackBar("Please enter a valid quantity");
      return false;
    }
    if (_selectedLocation == null) {
      _showSnackBar("Please select a location");
      return false;
    }
    if (_sellerNameController.text.isEmpty) {
      _showSnackBar("Please enter seller name");
      return false;
    }
    if (_contactInfoController.text.isEmpty) {
      _showSnackBar("Please enter contact information");
      return false;
    }
    if (_selectedImages.isEmpty && _existingImageUrls.isEmpty) {
      _showSnackBar("Please add at least one product photo");
      return false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      return;
    }

    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    // Show detailed loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text("Uploading..."),
            const SizedBox(height: 8),
            Text(
              "Uploading ${_selectedImages.length} new image(s)",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "This may take a few moments",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

    try {
      print('=== STARTING UPLOAD PROCESS ===');
      
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        // Upload images to Cloudinary
        print('📸 Starting image upload...');
        imageUrls = await _cloudinaryService.uploadMultipleImages(_selectedImages);
        
        print('📊 Upload results: ${imageUrls.length} successful, ${_selectedImages.length - imageUrls.length} failed');
        
        if (imageUrls.isEmpty) {
          Navigator.pop(context);
          _showDetailedErrorDialog(
            "All image uploads failed",
            "This could be due to:\n• No internet connection\n• Large file sizes\n• Cloudinary service issue\n• Incorrect upload preset\n\nPlease check your connection and try again with smaller images.",
          );
          return;
        }

        if (imageUrls.length < _selectedImages.length) {
          // Some images failed, but some succeeded
          _showSnackBar("⚠️ ${imageUrls.length}/${_selectedImages.length} images uploaded successfully. Continuing with available images.");
        }
      }

      print('✅ Images uploaded! Saving to Firestore...');
      
      // Get current user ID for sellerId
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User not authenticated");
      }

      // Combine existing and new image URLs
      List<String> finalImageUrls = [..._existingImageUrls, ...imageUrls];
      
      // Create agricultural item with combined URLs
      AgriculturalItem item = AgriculturalItem(
        id: widget.productToEdit?.id, // Keep existing ID if editing
        name: _nameController.text,
        category: _selectedCategory,
        subcategory: _subcategoryController.text.isNotEmpty ? _subcategoryController.text : null,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        unit: _selectedUnit,
        condition: _selectedCondition,
        imageUrls: finalImageUrls,
        location: _selectedLocation,
        sellerName: _sellerNameController.text,
        sellerId: widget.productToEdit?.sellerId ?? currentUser.uid,
        contactInfo: _contactInfoController.text,
        availableFrom: _availableFrom,
        deliveryAvailable: _deliveryAvailable,
        tags: _tags.isNotEmpty ? _tags : null,
        likes: widget.productToEdit?.likes ?? 0,
        views: widget.productToEdit?.views ?? 0,
        createdAt: widget.productToEdit?.createdAt,
      );

      if (widget.productToEdit != null) {
        // Update existing item
        bool success = await _firestoreService.updateAgriculturalItem(widget.productToEdit!.id!, item);
        Navigator.pop(context); // Close loading dialog
        
        if (success) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Product updated successfully!")),
           );
           Navigator.pop(context); // Go back to previous screen
        } else {
           _showSnackBar("❌ Failed to update item.");
        }
      } else {
        // Save new item to Firestore
        String? itemId = await _firestoreService.addAgriculturalItem(item);
        
        Navigator.pop(context); // Close loading dialog

        if (itemId != null) {
          print('🎉 SUCCESS! Item saved with ID: $itemId');
          _showSuccessMessage(item, imageUrls.length);
        } else {
          _showSnackBar("❌ Failed to save item to database.");
        }
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      print('❌ Network error: $e');
      _showDetailedErrorDialog(
        "No Internet Connection",
        "Please check your internet connection and try again. Image upload requires an active internet connection.",
      );
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      print('❌ Timeout error: $e');
      _showDetailedErrorDialog(
        "Upload Timeout",
        "The upload is taking too long. This could be due to:\n• Slow internet connection\n• Large image files\n• Cloudinary service delay\n\nPlease try again with smaller images or better internet.",
      );
    } catch (e) {
      Navigator.pop(context);
      print('❌ Unexpected error: $e');
      _showDetailedErrorDialog(
        "Upload Failed",
        "An unexpected error occurred:\n\n$e\n\nPlease try again or contact support if the problem continues.",
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Helper method for detailed error dialogs
  void _showDetailedErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitForm(); // Retry
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  // Success message to show image count
  void _showSuccessMessage(AgriculturalItem item, int imageCount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("✅ Success!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item.name} has been listed successfully!"),
            const SizedBox(height: 8),
            Text("$imageCount image(s) uploaded to Cloudinary"),
            const SizedBox(height: 8),
            const Text("Your item is now live on the marketplace."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearForm();
            },
            child: const Text("Add Another"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearForm();
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _categoryController.clear();
      _subcategoryController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _quantityController.clear();
      _selectedLocation = null;
      locationController.clear();
      _sellerNameController.clear();
      _contactInfoController.clear();
      _tagsController.clear();
      _selectedCategory = '';
      _selectedCondition = 'Fresh';
      _selectedUnit = 'kg';
      _availableFrom = DateTime.now();
      _deliveryAvailable = false;
      _existingImageUrls.clear();
      _selectedImages.clear();
      _tags.clear();
    });
    _loadCurrentUserInfo(); // Reload user info after clearing
    _showSnackBar("Form cleared");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productToEdit != null ? 'Edit Product' : 'Sell Produce'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images Section
            _buildSectionHeader("Product Images"),
            const SizedBox(height: 8),
            
            if (_selectedImages.isNotEmpty || _existingImageUrls.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _existingImageUrls.length + _selectedImages.length,
                itemBuilder: (context, index) {
                  if (index < _existingImageUrls.length) {
                    // Existing image
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(_existingImageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeExistingImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  
                  // New selected image
                  final newImageIndex = index - _existingImageUrls.length;
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[newImageIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(newImageIndex),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            
            const SizedBox(height: 12),
            
            Container(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.add_photo_alternate),
                label: Text(
                  _selectedImages.isEmpty 
                    ? "Add Product Photos" 
                    : "Add More Photos (${_selectedImages.length}/10)",
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            if (_selectedImages.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Add clear photos of your product from different angles",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            
            const SizedBox(height: 20),

            // Product Information Section
            _buildSectionHeader("Product Information"),
            _buildTextField(_nameController, "Product Name *", Icons.shopping_basket),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
              decoration: const InputDecoration(
                labelText: "Category *",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: 12),

            _buildTextField(_subcategoryController, "Subcategory (Optional)", Icons.subtitles),
            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description *",
                border: OutlineInputBorder(),
                hintText: "Describe your product in detail...",
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price (ETB) *",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: "0.00",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity *",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale),
                      hintText: "0",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: "Unit",
                      border: OutlineInputBorder(),
                    ),
                    items: _units.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUnit = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    decoration: const InputDecoration(
                      labelText: "Condition",
                      border: OutlineInputBorder(),
                    ),
                    items: _conditions.map((String condition) {
                      return DropdownMenuItem<String>(
                        value: condition,
                        child: Text(condition),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCondition = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location Section
            _buildSectionHeader("Location"),
            TextField(
              controller: locationController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Location Coordinates *",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map, color: Colors.green),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapTestScreen(
                          onLocationSelected: _onLocationSelected,
                        ),
                      ),
                    );
                  },
                  tooltip: "Select Location on Map",
                ),
                hintText: "Tap map icon to select location",
              ),
            ),
            const SizedBox(height: 20),

            // Seller Information Section
            _buildSectionHeader("Seller Information"),
            _buildTextField(_sellerNameController, "Seller Name *", Icons.person),
            const SizedBox(height: 12),
            _buildTextField(_contactInfoController, "Contact Information *", Icons.phone),
            const SizedBox(height: 12),

            // Availability Section
            _buildSectionHeader("Availability"),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showDatePicker,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Available From",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today),
                          hintText: _availableFrom?.toString().split(' ')[0] ?? "Select date",
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilterChip(
                    label: Text(_deliveryAvailable ? "Delivery Available" : "No Delivery"),
                    selected: _deliveryAvailable,
                    onSelected: (bool selected) {
                      setState(() {
                        _deliveryAvailable = selected;
                      });
                    },
                    checkmarkColor: Colors.white,
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tags Section
            _buildSectionHeader("Tags (Optional)"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: "Add Tags",
                      border: OutlineInputBorder(),
                      hintText: "e.g., organic, premium, local",
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTag,
                  tooltip: "Add Tag",
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Display tags
            if (_tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: List.generate(_tags.length, (index) {
                  return Chip(
                    label: Text(_tags[index]),
                    onDeleted: () => _removeTag(index),
                    deleteIconColor: Colors.red,
                  );
                }),
              ),

            const SizedBox(height: 30),

            // Submit Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUploading ? Colors.grey : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("Uploading..."),
                        ],
                      )
                    : const Text(
                        "List Product for Sale",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _subcategoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    locationController.dispose();
    _sellerNameController.dispose();
    _contactInfoController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}