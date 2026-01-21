import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Chat/chat_screen.dart';
import 'package:echat/Services/chat_service.dart';
import 'package:echat/User%20Credential/userfirestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();
  final UserRepository _userRepo = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No messages yet", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return _buildChatListItem(doc);
            },
          );
        },
      ),
    );
  }

  Widget _buildChatListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String otherUserId = data['otherUserId'];
    String lastMessage = data['lastMessage'] ?? "";
    Timestamp timestamp = data['timestamp'];

    return FutureBuilder(
      future: _userRepo.getUser(otherUserId),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const SizedBox.shrink(); // Loading state hidden
        }

        final user = userSnapshot.data!;
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal[100],
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "?",
                style: TextStyle(color: Colors.teal[800]),
              ),
            ),
            title: Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            trailing: Text(
              _formatDate(timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: user.fullName,
                    receiverUserID: user.uid,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return DateFormat('HH:mm').format(date);
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }
}
