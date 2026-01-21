
import 'package:echat/User%20Credential/create_account.dart';
import 'package:echat/User%20Credential/forget_password.dart';
import 'package:echat/User%20Credential/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TextField.dart';
import 'firebaseauthservice.dart';
import 'userfirestore.dart';    
class RegistrationPage extends StatefulWidget {
  final void Function()? onTap;
  const RegistrationPage({super.key, required this.onTap});
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}
class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final FirebaseAuthService authService = FirebaseAuthService();
  final UserRepository _userRepository = UserRepository();
  bool _isLoading = false;
  String? _selectedUserType;
  Future<void> register() async {
    final _email = email.text.trim();
    final _password = password.text.trim();
    final _confirmPassword = confirmPassword.text.trim();
    final _fullName = fullName.text.trim();
    final _phoneNumber = phoneNumber.text.trim();

    // Validation
    if (_email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty || 
        _fullName.isEmpty || _phoneNumber.isEmpty || _selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (_password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create user with Firebase Auth
      final userCredential = await authService.signUp(_email, _password);
      final user = userCredential.user;

      if (user != null) {
        // Create user profile in Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: _email,
          fullName: _fullName,
          phoneNumber: _phoneNumber,
          userType: _selectedUserType!,
          profileCompleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(userModel);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );

        // Navigate to create account to complete profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateAccount()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";
      if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, size: 80, color: Colors.green[700]),
                const SizedBox(height: 20),
                Text(
                  "AgriLead",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Create your account",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Full Name
                Mytextfield(
                  con: fullName,
                  HintText: "Enter your full name",
                  valid: false,
                ),
                const SizedBox(height: 15),

                // Email
                Mytextfield(
                  con: email,
                  HintText: "Enter your email",
                  valid: false,
                ),
                const SizedBox(height: 15),

                // Phone Number
                Mytextfield(
                  con: phoneNumber,
                  HintText: "Enter your phone number",
                  valid: false,
                ),
                const SizedBox(height: 15),

                // User Type Selection
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButtonFormField<String>(
                      value: _selectedUserType,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: "Select your role",
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'farmer',
                          child: Text('Farmer'),
                        ),
                        DropdownMenuItem(
                          value: 'vendor',
                          child: Text('Vendor'),
                        ),
                           DropdownMenuItem(
                          value: 'advisor',
                          child: Text('Expert Advisor'),
                        ),
                              DropdownMenuItem(
                          value: 'delivery',
                          child: Text('Delivery'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                Mytextfield(
                  con: password,
                  HintText: "Enter your password",
                  valid: true,
                ),
                const SizedBox(height: 15),

                // Confirm Password
                Mytextfield(
                  con: confirmPassword,
                  HintText: "Confirm your password",
                  valid: true,
                ),
                const SizedBox(height: 25),

                // Register Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: register,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}