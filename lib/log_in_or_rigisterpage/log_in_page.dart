import 'package:echat/home/homepages.dart';
import 'package:echat/log_in_or_rigisterpage/create_account/create_account.dart';
import 'package:echat/log_in_or_rigisterpage/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chattpage/component/mytextfield.dart';
import 'firebaseauthservice.dart';

class LogInPage extends StatefulWidget {
  final void Function()? onTap;
  const LogInPage({super.key, required this.onTap});
  
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FirebaseAuthService signin = FirebaseAuthService();
  bool _isLoading = false;

  Future<void> login() async {
    final _email = email.text.trim();
    final _password = password.text.trim();

    if (_email.isEmpty || _password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Sign in with Firebase Auth
      final userCredential = await signin.signIn(_email, _password);
      final user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: "user-not-found",
          message: "User not found",
        );
      }

      print("✅ Firebase Auth successful, checking user profile...");

      // Check if user profile is completed
      final userDoc = await FirebaseFirestore.instance
          .collection('Usersstore')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // User doesn't exist in Usersstore - redirect to create account
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please complete your profile setup."),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateAccount()),
        );
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final profileCompleted = userData['profileCompleted'] ?? false;

      print("📊 User profile status: $profileCompleted");

      if (!profileCompleted) {
        // Profile not completed - redirect to create account
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please complete your profile."),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateAccount()),
        );
      } else {
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepages()),
        );
      }

    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') message = "User not found";
      else if (e.code == 'wrong-password') message = "Wrong password";
      else if (e.code == 'invalid-email') message = "Invalid email";
      else if (e.code == 'user-disabled') message = "User disabled";
      
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
                const SizedBox(height: 10),
                const Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                Mytextfield(
                  con: email,
                  HintText: "Enter your email",
                  valid: false,
                ),
                const SizedBox(height: 15),

                Mytextfield(
                  con: password,
                  HintText: "Enter your password",
                  valid: true,
                ),
                const SizedBox(height: 25),

                _isLoading
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: login,
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
                              "Login",
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
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPassword()),
                    );
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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