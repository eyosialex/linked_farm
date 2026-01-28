import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, audio, pdf }

class Message {
  final String senderId;
  final String senderEmail;
  final String? receiverId;
  final String? groupId;
  final String message;
  final Timestamp timestamp;
  final MessageType messageType;
  final String? mediaUrl;
  final String? fileName;
  final String? parentMessageId; // For threading/comments

  Message({
    required this.senderId,
    required this.senderEmail,
    this.receiverId,
    this.groupId,
    required this.message,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.mediaUrl,
    this.fileName,
    this.parentMessageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'groupId': groupId,
      'message': message,
      'timestamp': timestamp,
      'messageType': messageType.name,
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'parentMessageId': parentMessageId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      groupId: map['groupId'],
      message: map['message'],
      timestamp: map['timestamp'],
      messageType: MessageType.values.byName(map['messageType'] ?? 'text'),
      mediaUrl: map['mediaUrl'],
      fileName: map['fileName'],
      parentMessageId: map['parentMessageId'],
    );
  }
}
