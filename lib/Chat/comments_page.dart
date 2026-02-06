import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedfarm/Chat/chat_model.dart';
import 'package:linkedfarm/Services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentsPage extends StatefulWidget {
  final String groupId;
  final String parentMessageId;
  final String originalMessage;
  final String originalSenderName;

  const CommentsPage({
    super.key,
    required this.groupId,
    required this.parentMessageId,
    required this.originalMessage,
    required this.originalSenderName,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;

    await _chatService.sendGroupMessage(
      widget.groupId,
      _commentController.text.trim(),
      parentMessageId: widget.parentMessageId,
    );

    _commentController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 50,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Original Message Preview
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.reply, color: Colors.green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.originalSenderName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green),
                      ),
                      Text(
                        widget.originalMessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getComments(widget.groupId, widget.parentMessageId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No comments yet. Be the first!"));
                }

                // Sort comments in memory to avoid Firestore index requirement
                final docs = snapshot.data!.docs;
                docs.sort((a, b) {
                  Timestamp t1 = a['timestamp'];
                  Timestamp t2 = b['timestamp'];
                  return t1.compareTo(t2);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final bool isMe = data['senderId'] == FirebaseAuth.instance.currentUser?.uid;

                    return _buildCommentBubble(data, isMe);
                  },
                );
              },
            ),
          ),

          // Input field
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildCommentBubble(Map<String, dynamic> data, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                data['senderEmail'].split('@')[0],
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            Text(data['message']),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format((data['timestamp'] as Timestamp).toDate()),
              style: TextStyle(fontSize: 8, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  fillColor: Colors.grey[100],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendComment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
