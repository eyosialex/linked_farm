import 'package:echat/home/homepages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chattpage/chattpages.dart';
import '../chattpage/component/mytextfield.dart';
import 'firebaseauthservice.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final FirebaseAuthService authService = FirebaseAuthService();
  bool _isLoading = false;

  Future<void> register() async {
    final _email = email.text.trim();
    final _password = password.text.trim();
    final _confirmPassword = confirmPassword.text.trim();

    if (_email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
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

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await authService.signUp(_email, _password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registered Successfully: ${userCredential.user?.email}"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepages()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";

      if (e.code == 'email-already-in-use') message = "Email already in use";
      else if (e.code == 'weak-password') message = "Weak password";
      else if (e.code == 'invalid-email') message = "Invalid email";
      else if (e.code == 'operation-not-allowed') message = "Operation not allowed";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Mytextfield(
                con: email,
                HintText: "Enter your email",
                valid: false,
              ),
              const SizedBox(height: 10),
              Mytextfield(
                con: password,
                HintText: "Enter your password",
                valid: true,
              ),
              const SizedBox(height: 10),
              Mytextfield(
                con: confirmPassword,
                HintText: "Confirm password",
                valid: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: register,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
