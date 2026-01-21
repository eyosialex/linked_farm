import 'package:cloud_firestore/cloud_firestore.dart';

class AdviceModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String category; // e.g., "Crop Care", "Animal Health"
  final DateTime timestamp;
  final int likes;

  AdviceModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.category,
    required this.timestamp,
    this.likes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
    };
  }

  factory AdviceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AdviceModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      category: data['category'] ?? 'General',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
    );
  }
}
