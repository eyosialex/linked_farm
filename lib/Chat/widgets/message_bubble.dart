import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:linkedfarm/Chat/chat_model.dart';
import 'package:linkedfarm/Chat/widgets/media_preview.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isMe;
  final String? senderName;

  const MessageBubble({
    super.key,
    required this.data,
    required this.isMe,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    var bubbleColor = isMe ? Colors.green[600] : Colors.grey[200];
    var textColor = isMe ? Colors.white : Colors.black87;
    var alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;

    var typeStr = data['messageType'] ?? 'text';
    MessageType type = MessageType.values.byName(typeStr);
    String? mediaUrl = data['mediaUrl'];
    String? fileName = data['fileName'];
    dynamic timestampData = data['timestamp'];
    DateTime timestamp = timestampData is Timestamp ? timestampData.toDate() : DateTime.now();

    return Container(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe && senderName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  senderName!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            if (type == MessageType.text)
              MarkdownBody(
                data: data['message'],
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 16, color: textColor),
                ),
              )
            else
              MediaPreview(
                type: type,
                url: mediaUrl,
                fileName: fileName,
                textColor: textColor,
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(timestamp),
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
