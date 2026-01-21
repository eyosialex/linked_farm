import 'package:echat/Dlivery%20View/Delivery_Home_Page.dart';
import 'package:echat/Farmers%20View/Farmers_Home.dart';
import 'package:echat/Vendors%20View/Product_Home.dart';
import 'package:echat/User%20Credential/userfirestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'log_in_page.dart';
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}
class _CreateAccountState extends State<CreateAccount> {
  final UserRepository _userRepository = UserRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  int _currentStep = 0;

  // Form controllers for all user types
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _farmLocationController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  final TextEditingController _cropsController = TextEditingController();
  //form control for business or for the vendor
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _businessAddressController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();
  
final TextEditingController _addreess=TextEditingController();
final TextEditingController _drivinglisence=TextEditingController();
final TextEditingController _cartype=TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("🔄 Loading user data for: ${user.uid}");
      final userData = await _userRepository.getUser(user.uid);
      if (userData != null) {
        setState(() {
          _userData = {
            'uid': userData.uid,
            'email': userData.email,
            'fullName': userData.fullName,
            'phoneNumber': userData.phoneNumber,
            'userType': userData.userType,
          };
        });
        print("✅ User data loaded: ${userData.fullName} - ${userData.userType}");
      } else {
        print("❌ No user data found in Firestore");
      }
    } else {
      print("❌ No user logged in");
    }
  }

  Future<void> _completeProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    if (_userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not found")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> profileData = {};

      if (_userData!['userType'] == 'farmer') {
        profileData = {
          'farmName': _farmNameController.text.trim(),
          'farmLocation': _farmLocationController.text.trim(),
          'farmSize': _farmSizeController.text.trim(),
          'crops': _cropsController.text.trim(),
          'profileCompleted': true,
        };
      } else if (_userData!['userType'] == 'vendor') {
        profileData = {
          'businessName': _businessNameController.text.trim(),
          'businessType': _businessTypeController.text.trim(),
          'contactPerson': _contactPersonController.text.trim(),
          'businessAddress': _businessAddressController.text.trim(),
          'products': _productsController.text.trim(),
          'profileCompleted': true,
        };
      }
       else if (_userData!['userType'] == 'delivery') {
        profileData = {
        
          'cartype': _cartype.text.trim(),
          'adress': _addreess.text.trim(),
          'deriving licence': _drivinglisence.text.trim(),
          'profileCompleted': true,
        };}
      
      await _userRepository.completeUserProfile(user.uid, profileData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile completed successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Widget targetPage;
      if (_userData!['userType'] == 'farmer') {
        targetPage = const FarmersHomePage();
      } else if (_userData!['userType'] == 'vendor') {
        targetPage = const vendors_page();
      } else if (_userData!['userType'] == 'delivery') {
        targetPage = const Delivery_Home_Page();
      } else {
        targetPage = const FarmersHomePage();
      }

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );

    } catch (e) {
      print("❌ Error completing profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to complete profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Step> _buildSteps() {
    if (_userData == null) {
      return [];
    }

    final userType = _userData!['userType'];
    
    if (userType == 'farmer') {
      return _buildFarmerSteps();
    } else if (userType == 'vendor') {
      return _buildVendorSteps();
    }
   
    else if (userType == 'delivery') {
      return _builddliverySteps();
    }
    return [];
  }

  List<Step>_builddliverySteps() {
    return [
      Step(
        title: const Text('Delivery Information'),
        content: Column(
          children: [
         
            const SizedBox(height: 15),
            TextField(
              controller:_addreess,
              decoration: const InputDecoration(
                labelText: 'your location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _cartype,
              decoration: const InputDecoration(
                labelText: 'Car Type',
                border: OutlineInputBorder(),
              ),
           
            ),
            const SizedBox(height: 15),
            TextField(
              controller:_drivinglisence ,
              decoration: const InputDecoration(
                labelText: 'Driven license id',
                border: OutlineInputBorder(),
                hintText: 'driven licence id ',
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Review & Complete'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review your information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Location: ${_addreess.text}'),
            Text('Driven licence id : ${_drivinglisence.text} '),
            Text('Car Type: ${_cartype.text}'),
            const SizedBox(height: 20),
            const Text(
              'Click Complete to finish your profile setup.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
    ];
  }


  List<Step> _buildFarmerSteps() {
    return [
      Step(
        title: const Text('Farm Information'),
        content: Column(
          children: [
            TextField(
              controller: _farmNameController,
              decoration: const InputDecoration(
                labelText: 'Farm Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _farmLocationController,
              decoration: const InputDecoration(
                labelText: 'Farm Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _farmSizeController,
              decoration: const InputDecoration(
                labelText: 'Farm Size (acres)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _cropsController,
              decoration: const InputDecoration(
                labelText: 'Crops Grown',
                border: OutlineInputBorder(),
                hintText: 'e.g., Coffee, Maize, Vegetables',
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Review & Complete'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review your information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Farm Name: ${_farmNameController.text}'),
            Text('Location: ${_farmLocationController.text}'),
            Text('Farm Size: ${_farmSizeController.text} acres'),
            Text('Crops: ${_cropsController.text}'),
            const SizedBox(height: 20),
            const Text(
              'Click Complete to finish your profile setup.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
    ];
  }

  List<Step> _buildVendorSteps() {
    return [
      Step(
        title: const Text('Business Information'),
        content: Column(
          children: [
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _businessTypeController,
              decoration: const InputDecoration(
                labelText: 'Business Type',
                border: OutlineInputBorder(),
                hintText: 'e.g., Supplier, Retailer, Wholesaler',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contactPersonController,
              decoration: const InputDecoration(
                labelText: 'Contact Person',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _businessAddressController,
              decoration: const InputDecoration(
                labelText: 'Business Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _productsController,
              decoration: const InputDecoration(
                labelText: 'Products/Services',
                border: OutlineInputBorder(),
                hintText: 'e.g., Fertilizers, Seeds, Equipment',
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Review & Complete'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review your information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Business Name: ${_businessNameController.text}'),
            Text('Business Type: ${_businessTypeController.text}'),
            Text('Contact Person: ${_contactPersonController.text}'),
            Text('Address: ${_businessAddressController.text}'),
            Text('Products: ${_productsController.text}'),
            const SizedBox(height: 20),
            const Text(
              'Click Complete to finish your profile setup.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
    ];
  }
  String _getUserTypeDisplay() {
    if (_userData == null) return '';
    
    switch (_userData!['userType']) {
      case 'farmer':
        return 'Farmer Profile Setup';
      case 'vendor':
        return 'Vendor Profile Setup';
      case 'advisor':
        return 'Expert Advisor Profile Setup';
      default:
        return 'Profile Setup';
    }
  }

  IconData _getUserTypeIcon() {
    if (_userData == null) return Icons.person;
    
    switch (_userData!['userType']) {
      case 'farmer':
        return Icons.agriculture;
      case 'vendor':
        return Icons.business;
      case 'advisor':
        return Icons.school;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Complete Your Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LogInPage(onTap: (){})),
            );
          },
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              _getUserTypeIcon(),
                              color: Colors.green[700],
                              size: 40,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome, ${_userData!['fullName']}!",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _getUserTypeDisplay(),
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stepper
                    Expanded(
                      child: Stepper(
                        currentStep: _currentStep,
                        onStepContinue: () {
                          if (_currentStep < _buildSteps().length - 1) {
                            setState(() {
                              _currentStep++;
                            });
                          } else {
                            _completeProfile();
                          }
                        },
                        onStepCancel: () {
                          if (_currentStep > 0) {
                            setState(() {
                              _currentStep--;
                            });
                          }
                        },
                        steps: _buildSteps(),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}