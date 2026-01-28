import 'package:echat/User%20Credential/TextField.dart';
import 'package:echat/User%20Credential/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final email = emailController.text.trim();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        _message = "✅ ${AppLocalizations.of(context)!.resetLinkSent}";
        _isSuccess = true;
      });
    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = l10n.noAccountFound;
          break;
        case 'invalid-email':
          errorMessage = l10n.invalidEmailFormat;
          break;
        case 'network-request-failed':
          errorMessage = l10n.networkError;
          break;
        default:
          errorMessage = e.message ?? l10n.somethingWentWrong;
      }
      setState(() {
        _message = errorMessage;
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text(
                AppLocalizations.of(context)!.passwordRecoveryTitle,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your registered email',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 30),

              // ✅ Connect Mytextfield with validation
              Mytextfield(
                con: emailController,
                HintText: AppLocalizations.of(context)!.emailAddressLabel,
                valid: true,
              ),

              const SizedBox(height: 20),

              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isSuccess ? Colors.green[800] : Colors.red[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_message, style: const TextStyle(color: Colors.white)),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(AppLocalizations.of(context)!.sendResetLinkButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.noAccount, style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage(onTap: () {})));
                      },
                      child: Text(AppLocalizations.of(context)!.signUpAction, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
