import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Services/chat_service.dart';
import 'package:echat/Chat/chat_model.dart';
import 'package:echat/Chat/image_preview_page.dart';
import 'package:echat/Chat/widgets/chat_input_field.dart';
import 'package:echat/Chat/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showEmoji = false;
  bool _isUploading = false;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendGroupMessage(
        widget.groupId,
        _messageController.text,
        type: MessageType.text,
      );
      _messageController.clear();
    }
  }

  Future<void> _pickAndSendMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'mp4', 'mp3', 'pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      String ext = result.files.single.extension?.toLowerCase() ?? '';
      
      setState(() => _isUploading = true);
      
      try {
        MessageType type = MessageType.text;
        if (['jpg', 'png', 'jpeg'].contains(ext)) type = MessageType.image;
        else if (ext == 'mp4') type = MessageType.video;
        else if (ext == 'mp3') type = MessageType.audio;
        else if (ext == 'pdf') type = MessageType.pdf;

        String url = await _chatService.uploadMedia(file, 'group_media');
        
        await _chatService.sendGroupMessage(
          widget.groupId,
          "[Media: $fileName]",
          type: type,
          mediaUrl: url,
          fileName: fileName,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getGroupMessages(widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(10),
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isMe = data['senderId'] == _auth.currentUser!.uid;
    String? mediaUrl = data['mediaUrl'];
    String? typeStr = data['messageType'];

    return GestureDetector(
      onTap: () {
        if (typeStr == MessageType.image.name && mediaUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePreviewPage(imageUrl: mediaUrl),
            ),
          );
        }
      },
      child: MessageBubble(
        data: data,
        isMe: isMe,
        senderName: data['senderEmail'],
      ),
    );
  }

  Widget _buildMessageInput() {
    return ChatInputField(
      controller: _messageController,
      onSend: sendMessage,
      onAttach: _pickAndSendMedia,
      isUploading: _isUploading,
    );
  }
}
