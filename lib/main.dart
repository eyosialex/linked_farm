import 'package:echat/chattpage/chattpages.dart';
import 'package:echat/home/homepages.dart';
import 'package:echat/log_in_or_rigisterpage/forget_password.dart';
import 'package:echat/log_in_or_rigisterpage/log_in_or_register.dart';
import 'package:echat/log_in_or_rigisterpage/log_in_page.dart';
import 'package:echat/nationalidverification/inputphoto.dart';
import 'package:echat/sell%20item/position.dart';
import 'package:echat/sell%20item/selectsellitem.dart';
import 'package:echat/show%20product%20items/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
 class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final TextEditingController textCon=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ), 
      
      home : LogInOrRegister(),
    );
  }
}