import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final bool isUploading;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    this.isUploading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isUploading) const LinearProgressIndicator(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, -1),
              )
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined,
                  color: Colors.grey[600],
                ),
                onPressed: () => setState(() => _showEmoji = !_showEmoji),
              ),
              IconButton(
                icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                onPressed: widget.onAttach,
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onTap: () {
                    if (_showEmoji) setState(() => _showEmoji = false);
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal[700],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: widget.onSend,
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        if (_showEmoji)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                widget.controller.text += emoji.emoji;
              },
            ),
          ),
      ],
    );
  }
}
