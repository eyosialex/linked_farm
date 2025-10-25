import 'package:echat/home/homepages.dart';
import 'package:echat/log_in_or_rigisterpage/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chattpage/chattpages.dart';
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

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await signin.signIn(_email, _password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful: ${userCredential.user?.email}"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepages()),
      );
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
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: login,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));

                },
                child: Text("forget password ?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),))
,
                SizedBox(height: 50,),
                //Text('OR LogIn With ',style: TextStyle(color: Colors.black,fontSize: 25),),
              
            ],
          ),
        ),
      ),
    );
  }
}
