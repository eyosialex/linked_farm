import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String name;
  final List<String> members;
  final String lastMessage;
  final String lastSenderId;
  final Timestamp timestamp;
  final String? groupIconUrl;

  GroupModel({
    required this.groupId,
    required this.name,
    required this.members,
    required this.lastMessage,
    required this.lastSenderId,
    required this.timestamp,
    this.groupIconUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'members': members,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'timestamp': timestamp,
      'groupIconUrl': groupIconUrl,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'],
      name: map['name'],
      members: List<String>.from(map['members']),
      lastMessage: map['lastMessage'],
      lastSenderId: map['lastSenderId'],
      timestamp: map['timestamp'],
      groupIconUrl: map['groupIconUrl'],
    );
  }
}
