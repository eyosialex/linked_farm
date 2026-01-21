import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:echat/Services/websocket_service.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WebSocketService _webSocketService = WebSocketService();

  ChatService() {
    _webSocketService.connect();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  // EXPOSE WEBSOCKET STREAM
  Stream get webSocketStream => _webSocketService.stream;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Send via WebSocket for "Instant" real-time (demo purposes)
    _webSocketService.sendMessage(currentUserId, receiverID, message);

    // create a new message for Firestore persistence
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverID];
    ids.sort(); // sort the ids (this ensures the chatRoomId is always the same for any 2 people)
    String chatRoomId = ids.join('_');

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Update 'latest_message' for both users to build the "Inbox" list
    // 1. For Current User
    await _firestore
        .collection('user_chats')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverID)
        .set({
      'chatRoomId': chatRoomId,
      'otherUserId': receiverID,
      'lastMessage': message,
      'timestamp': timestamp,
      // We might need to fetch the receiver's name separately or pass it in method, 
      // but for now we rely on fetching user details in the list.
    }, SetOptions(merge: true));

    // 2. For Receiver
    await _firestore
        .collection('user_chats')
        .doc(receiverID)
        .collection('chats')
        .doc(currentUserId)
        .set({
      'chatRoomId': chatRoomId,
      'otherUserId': currentUserId,
      'lastMessage': message,
      'timestamp': timestamp,
    }, SetOptions(merge: true));
  }
  
  // GET USER CHATS (INBOX)
  Stream<QuerySnapshot> getUserChats() {
    final String currentUserId = _auth.currentUser!.uid;
    return _firestore
        .collection('user_chats')
        .doc(currentUserId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room ID for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  // convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
