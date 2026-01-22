import 'package:flutter/material.dart';
import 'package:echat/Chat/chat_model.dart';

class MediaPreview extends StatelessWidget {
  final MessageType type;
  final String? url;
  final String? fileName;
  final Color textColor;

  const MediaPreview({
    super.key,
    required this.type,
    this.url,
    this.fileName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Text(
        "Error: Media not found",
        style: TextStyle(color: textColor, fontSize: 12),
      );
    }

    switch (type) {
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url!,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
          ),
        );
      case MessageType.video:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.video_library, size: 30, color: Colors.blue),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                fileName ?? "Video File",
                style: TextStyle(color: textColor, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      case MessageType.audio:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.audiotrack, size: 30, color: Colors.orange),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                fileName ?? "Audio File",
                style: TextStyle(color: textColor, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      case MessageType.pdf:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf, size: 30, color: Colors.red),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                fileName ?? "PDF Document",
                style: TextStyle(color: textColor, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      default:
        return Text(
          "Unsupported media",
          style: TextStyle(color: textColor, fontSize: 12),
        );
    }
  }
}
