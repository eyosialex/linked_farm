import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/chattpage/component/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chattservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get stream of all users
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('Usersstore').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userid': doc.id,
          'email': data['email'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'isOnline': data['isOnline'] ?? false,
          'lastseen': data['lastseen'],
        };
      }).toList();
    });
  }

  Future<void> sendmessage(String receiverId, String message) async {
    final String senderid = _firebaseAuth.currentUser!.uid;
    final String senderemail = _firebaseAuth.currentUser?.email ?? "";
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [senderid, receiverId];
    ids.sort();
    String chatroomid = ids.join('_');
    
    // Update user status to online when sending message
    await _firestore.collection('Usersstore').doc(senderid).set({
      "isOnline": true,
      "lastseen": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Save message to Firestore
    await _firestore
        .collection("ChattRoom")
        .doc(chatroomid)
        .collection("Messages")
        .add({
      'senderId': senderid,
      'senderEmail': senderemail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'read': false,
    }); 
  }

  Stream<QuerySnapshot> GetMessage(String userid, String otheruserid) {
    List<String> ids = [userid, otheruserid];
    ids.sort();
    String chatroomid = ids.join('_');
    return _firestore
        .collection("ChattRoom")
        .doc(chatroomid)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
  // ------------------ GROUPS ------------------
  Future<String> createGroup(String groupName, List<String> memberIds) async {
    final currentUser = _firebaseAuth.currentUser!;
    
    // Add current user to members if not already included
    if (!memberIds.contains(currentUser.uid)) {
      memberIds.add(currentUser.uid);
    }

    final groupDoc = await _firestore.collection("Groups").add({
      'groupName': groupName,
      'createdBy': currentUser.uid,
      'members': memberIds,
      'createdAt': Timestamp.now(),
      'createdByEmail': currentUser.email,
    });
    
    return groupDoc.id;
  }

  Future<void> sendGroupMessage(String groupId, String message) async {
    final String senderId = _firebaseAuth.currentUser!.uid;
    final String senderEmail = _firebaseAuth.currentUser!.email ?? '';
    final Timestamp timestamp = Timestamp.now();
    
    // Update user status to online when sending group message
    await _firestore.collection('Usersstore').doc(senderId).set({
      "isOnline": true,
      "lastseen": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Save group message
    await _firestore
        .collection("Groups")
        .doc(groupId)
        .collection("Messages")
        .add({
      'senderId': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
      'type': 'text',
    });
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection("Groups")
        .doc(groupId)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getUserGroups(String userId) {
    return _firestore
        .collection("Groups")
        .where("members", arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "groupId": doc.id,
          "name": data['groupName'] ?? 'Unnamed Group',
          "members": List<String>.from(data['members'] ?? []),
          "createdBy": data['createdBy'] ?? '',
        };
      }).toList();
    });
  }

  // ------------------ USER STATUS METHODS ------------------
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('Usersstore').doc(currentUser.uid).set({
        "isOnline": isOnline,
        "lastseen": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> updateUserProfilePhoto(String photoUrl) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('Usersstore').doc(currentUser.uid).set({
        "photoUrl": photoUrl,
      }, SetOptions(merge: true));
    }
  }

  // Get specific user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('Usersstore').doc(userId).get();
      if (doc.exists) {
        return {
          'userid': doc.id,
          ...doc.data()!,
        };
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  // ------------------ FCM TOKEN METHODS ------------------
  Future<void> updateUserFCMToken(String token) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('Usersstore').doc(currentUser.uid).set({
        'fcmToken': token,
        'lastLogin': Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> removeUserFCMToken() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('Usersstore').doc(currentUser.uid).set({
        'fcmToken': FieldValue.delete(),
      }, SetOptions(merge: true));
    }
  }
}
