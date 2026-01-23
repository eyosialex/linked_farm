import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'match', 'activity', 'system'

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'timestamp': FieldValue.serverTimestamp(),
    'isRead': isRead,
    'type': type,
  };

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AppNotification(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      type: data['type'] ?? 'system',
    );
  }
}
