import 'package:echat/Dlivery%20View/Delivery_Home_Page.dart';
import 'package:echat/Farmers%20View/Farmers_Home.dart';
import 'package:echat/Vendors%20View/Product_Home.dart';
import 'package:echat/Advisor%20View/Advisor_Home.dart';
import 'package:echat/Shopper%20View/Shopper_Home.dart';
import 'package:echat/User%20Credential/create_account.dart';
import 'package:echat/User%20Credential/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'TextField.dart';
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
        SnackBar(content: Text(AppLocalizations.of(context)!.fillAllFields)),
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.completeProfileSetup),
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.completeProfile),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateAccount()),
        );
      } else {
      
      final userType = userData['userType'];
        
        Widget targetPage;
        if (userType == 'farmer') {
          targetPage = const FarmersHomePage();
        } else if (userType == 'vendor') {
          targetPage = const vendors_page();
        } else if (userType == 'delivery') {
          targetPage = const Delivery_Home_Page();
        } else if (userType == 'advisor') {
          targetPage = const AdvisorHomePage();
        } else if (userType == 'shopper') {
          targetPage = const ShopperHomePage();
        } else {
          // Default
          targetPage = const FarmersHomePage();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      }

    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      String message = l10n.somethingWentWrong;
      if (e.code == 'user-not-found') message = l10n.userNotFound;
      else if (e.code == 'wrong-password') message = l10n.wrongPassword;
      else if (e.code == 'invalid-email') message = l10n.invalidEmail;
      else if (e.code == 'user-disabled') message = l10n.userDisabled;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.somethingWentWrong}: $e")),
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
                  AppLocalizations.of(context)!.appTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.loginSubTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                Mytextfield(
                  con: email,
                  HintText: AppLocalizations.of(context)!.emailHint,
                  valid: false,
                ),
                const SizedBox(height: 15),

                Mytextfield(
                  con: password,
                  HintText: AppLocalizations.of(context)!.passwordHint,
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
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.loginButton,
                              style: const TextStyle(
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
                    Text(AppLocalizations.of(context)!.noAccount),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        AppLocalizations.of(context)!.registerAction,
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
                    AppLocalizations.of(context)!.forgotPassword,
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