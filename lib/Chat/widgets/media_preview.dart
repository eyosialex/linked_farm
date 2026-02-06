import 'package:flutter/material.dart';
import 'package:linkedfarm/Chat/chat_model.dart';
import 'package:linkedfarm/Chat/widgets/audio_player_widget.dart';

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
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.video_library, size: 40, color: Colors.white54),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      fileName ?? "Video File",
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
            ),
          ],
        );
      case MessageType.audio:
        return AudioPlayerWidget(
          url: url!,
          themeColor: textColor,
        );
      case MessageType.pdf:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: textColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf, size: 30, color: Colors.red),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  fileName ?? "PDF Document",
                  style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      default:
        return Text(
          "Unsupported media",
          style: TextStyle(color: textColor, fontSize: 12),
        );
    }
  }
}
