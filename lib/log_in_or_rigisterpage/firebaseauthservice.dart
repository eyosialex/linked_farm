import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('Usersstore').doc(userCred.user!.uid).set({
        "userid": userCred.user!.uid,
        "email": email,
        "isOnline": true,
        "lastseen": FieldValue.serverTimestamp(),
        "photoUrl": "", // Initialize empty photoUrl
        'name':""
      });

      return userCred;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await setUserStatus(userCred.user!.uid, true);
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await setUserStatus(user.uid, false); 
      }
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> setUserStatus(String uid, bool isOnline) async {
    await _firestore.collection('Usersstore').doc(uid).set({
      "isOnline": isOnline,
      "lastseen": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); 
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<DocumentSnapshot> userStream(String uid) {
    return _firestore.collection('Usersstore').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getAllUsers(String currentUid) {
    return _firestore
        .collection('Usersstore')
        .where('userid', isNotEqualTo: currentUid)
        .snapshots();
  }
}