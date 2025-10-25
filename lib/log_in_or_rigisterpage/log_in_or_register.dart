import 'package:flutter/material.dart';
import 'log_in_page.dart';
import 'register_page.dart';

class LogInOrRegister extends StatefulWidget {
  const LogInOrRegister({super.key});
  @override
  State<LogInOrRegister> createState() => _LogInOrRegisterState();
}
class _LogInOrRegisterState extends State<LogInOrRegister> {
  bool showLogin = true;

  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLogin
          ? LogInPage(onTap: toggle)
          : RegisterPage(onTap: toggle),
    );
  }
}
