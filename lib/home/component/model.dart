import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final String senderemail;
  final Timestamp timestamp;
  Message({
    required this.senderId,
     required this.senderemail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderemail': senderemail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

}