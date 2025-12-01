import 'package:echat/chattpage/chattpages.dart';
import 'package:echat/log_in_or_rigisterpage/log_in_or_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController textCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeUserStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Set user offline when app closes
    _setUserOffline();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final user = _auth.currentUser;
    
    if (user != null) {
      switch (state) {
        case AppLifecycleState.resumed:
          _setUserOnline(user.uid);
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
          _setUserOffline();
          break;
      }
    }
  }

  void _initializeUserStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _setUserOnline(user.uid);
    }
  }

  Future<void> _setUserOnline(String uid) async {
    try {
      await _firestore.collection('Usersstore').doc(uid).update({
        'isOnline': true,
        'lastseen': FieldValue.serverTimestamp(),
      });
      print('✅ User set online: $uid');
    } catch (e) {
      print('❌ Error setting user online: $e');
    }
  }

  Future<void> _setUserOffline() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('Usersstore').doc(user.uid).update({
          'isOnline': false,
          'lastseen': FieldValue.serverTimestamp(),
        });
        print('✅ User set offline: ${user.uid}');
      } catch (e) {
        print('❌ Error setting user offline: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agrilead',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ), 
      home: LogInOrRegister(),
    );
  }
}