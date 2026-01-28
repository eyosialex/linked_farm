import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String name;
  final List<String> members;
  final List<String> adminIds;
  final String lastMessage;
  final String lastSenderId;
  final Timestamp timestamp;
  final String? groupIconUrl;
  final String type; // 'group' or 'channel'

  GroupModel({
    required this.groupId,
    required this.name,
    required this.members,
    required this.adminIds,
    required this.lastMessage,
    required this.lastSenderId,
    required this.timestamp,
    this.groupIconUrl,
    this.type = 'group',
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'members': members,
      'adminIds': adminIds,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'timestamp': timestamp,
      'groupIconUrl': groupIconUrl,
      'type': type,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'] ?? '',
      name: map['name'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      adminIds: List<String>.from(map['adminIds'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastSenderId: map['lastSenderId'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      groupIconUrl: map['groupIconUrl'],
      type: map['type'] ?? 'group',
    );
  }

  bool get isChannel => type == 'channel';
  bool isAdmin(String userId) => adminIds.contains(userId);
}
