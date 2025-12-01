import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/chattpage/chattservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class ChattMessage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChattMessage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChattMessage> createState() => _ChattMessageState();
}

class _ChattMessageState extends State<ChattMessage> {
  final TextEditingController _messageController = TextEditingController();
  final Chattservices _chattservices = Chattservices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  bool _isUploading = false;

  // Cloudinary Configuration
  final cloudinary = CloudinaryPublic(
    'dgp9dusw5', // Your Cloudinary cloud name
    'chattphoto', // Your unsigned upload preset name
    cache: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Send text message
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await _chattservices.sendmessage(widget.receiverId, text);
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
      _showCustomSnackBar("Message sent", Icons.check, Colors.green);
    }
  }

  // Pick and upload image to Cloudinary
  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1920,
      );

      if (pickedFile == null) return;

      setState(() {
        _isUploading = true;
      });

      // Show upload confirmation dialog
      final bool confirmUpload = await showDialog(
        context: context,
        builder: (context) => UploadConfirmationDialog(
          imagePath: pickedFile.path,
        ),
      );

      if (confirmUpload != true) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      print("[CLOUDINARY] Starting upload...");
      
      // Cloudinary upload
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "chat_images",
        ),
      ).timeout(const Duration(seconds: 30));

      print("[CLOUDINARY] Upload successful: ${response.secureUrl}");

      // Verify the URL is valid before sending
      if (response.secureUrl.isEmpty) {
        throw Exception("Cloudinary returned empty URL");
      }

      // Send the image URL as a message
      await _chattservices.sendmessage(widget.receiverId, response.secureUrl);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      _showCustomSnackBar("Image sent successfully", Icons.image, Colors.green);

    } on CloudinaryException catch (e) {
      print("[CLOUDINARY ERROR] ${e.message}");
      print("[CLOUDINARY ERROR] Status: ${e.statusCode}");
      
      String errorMessage = "Upload failed";
      if (e.statusCode == 400) {
        errorMessage = "Invalid image file";
      } else if (e.statusCode == 401) {
        errorMessage = "Cloudinary configuration error";
      } else if (e.statusCode == 413) {
        errorMessage = "Image file too large";
      } else if (e.statusCode == 500) {
        errorMessage = "Cloudinary server error";
      } else {
        errorMessage = "Upload failed: ${e.message}";
      }
      
      _showCustomSnackBar(errorMessage, Icons.error, Colors.red);
      
    } on TimeoutException catch (e) {
      print("[CLOUDINARY TIMEOUT] $e");
      _showCustomSnackBar("Upload timeout - check internet connection", Icons.error, Colors.red);
      
    } catch (e) {
      print("[UPLOAD ERROR] $e");
      _showCustomSnackBar("Upload failed: $e", Icons.error, Colors.red);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showCustomSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isMe = data['senderId'] == _firebaseAuth.currentUser!.uid;
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    DateTime time = timestamp.toDate();
    bool isImage = data['message'].toString().startsWith("http");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 14,
              child: Text(
                data['senderEmail'][0].toUpperCase(),
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[600] : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: isImage
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['message'],
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 200,
                                    height: 150,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print("[IMAGE LOAD ERROR] $error");
                                  return Container(
                                    width: 200,
                                    height: 150,
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error, color: Colors.red),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Failed to load image",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '📷 Photo',
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          data['message'],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue[200],
              radius: 14,
              child: Text(
                _firebaseAuth.currentUser!.email![0].toUpperCase(),
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chattservices.GetMessage(widget.receiverId, _firebaseAuth.currentUser!.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget("Error loading messages");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyWidget();
        }
        var sortedDocs = snapshot.data!.docs.toList()
          ..sort((a, b) {
            Timestamp timestampA = a['timestamp'] ?? Timestamp.now();
            Timestamp timestampB = b['timestamp'] ?? Timestamp.now();
            return timestampA.compareTo(timestampB); // Oldest first
          });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          itemCount: sortedDocs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(sortedDocs[index]);
          },
        );
      },
    );
  }
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey[400], size: 64),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Loading messages..."),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, color: Colors.grey[400], size: 64),
          const SizedBox(height: 16),
          Text(
            "No messages yet\nStart the conversation!",
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildLastSeen() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("Usersstore").doc(widget.receiverId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            "Offline",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          );
        }
        if (!snapshot.data!.exists) {
          return const Text(
            "Offline",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          );
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final isOnline = data["isOnline"] ?? false;
        final lastSeen = data["lastseen"];
        if (isOnline == true) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Online",
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          );
        } else if (lastSeen != null) {
          return Text(
            "Last seen ${_formatLastSeen(lastSeen.toDate())}",
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          );
        } else {
          return const Text(
            "Offline",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          );
        }
      },
    );
  }
  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) return "just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes} minutes ago";
    if (difference.inHours < 24) return "${difference.inHours} hours ago";
    if (difference.inDays == 1) return "1 day ago";
    if (difference.inDays < 7) return "${difference.inDays} days ago";
    if (difference.inDays < 30) return "${(difference.inDays / 7).floor()} weeks ago";
    return "a long time ago";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Text(
                widget.receiverEmail[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildLastSeen(),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarTextStyle: const TextStyle(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                
                IconButton(
                  icon: Icon(Icons.image, color: Colors.blue[600]),
                  onPressed: _isUploading ? null : _pickAndUploadImage,
                ),
                
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class UploadConfirmationDialog extends StatelessWidget {
  final String imagePath;

  const UploadConfirmationDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Send this image?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "SEND",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}