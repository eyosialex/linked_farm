import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/chattpage/chattservices.dart';
import 'package:echat/chattpage/component/mytextfield.dart';
import 'package:echat/chattpage/groupchat/change_profile.dart';
import 'package:echat/home/homepages.dart';
import 'package:echat/log_in_or_rigisterpage/firebaseauthservice.dart';
import 'package:echat/log_in_or_rigisterpage/log_in_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'chattmessage.dart';
import 'groupchat/groupmessage.dart';

class ChattPages extends StatefulWidget {
  const ChattPages({super.key});

  @override
  State<ChattPages> createState() => _ChattPagesState();
}

class _ChattPagesState extends State<ChattPages> {
  final Chattservices _chattservices = Chattservices();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController searchController = TextEditingController();
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'dgp9dusw5',
    'chattphoto',
    cache: false,
  );

  String searchQuery = '';
  bool showSearch = false;
  bool _isUploading = false;
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void toggleSearch() {
    setState(() {
      showSearch = !showSearch;
      if (!showSearch) {
        searchQuery = '';
        searchController.clear();
      }
    });
  }

  // Pick and upload profile photo to Cloudinary
  Future<void> _pickAndUploadProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
      );

      if (pickedFile == null) return;
      
      final bool confirmUpload = await showDialog(
        context: context,
        builder: (context) => UploadConfirmationDialog(imagePath: pickedFile.path),
      );

      if (confirmUpload != true) return;

      setState(() => _isUploading = true);

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "profile_images",
        ),
      ).timeout(const Duration(seconds: 30));

      if (response.secureUrl.isEmpty) {
        throw Exception("Cloudinary returned empty URL");
      }

      await FirebaseFirestore.instance
          .collection("Usersstore")
          .doc(currentUserId)
          .update({"photoUrl": response.secureUrl});

      if (!mounted) return;
      _showCustomSnackBar("Profile photo updated successfully!", Icons.check, Colors.green);
    } on CloudinaryException catch (e) {
      String errorMessage = "Upload failed: ${e.message}";
      _showCustomSnackBar(errorMessage, Icons.error, Colors.red);
    } on TimeoutException {
      _showCustomSnackBar("Upload timeout - check internet connection", Icons.error, Colors.red);
    } catch (e) {
      _showCustomSnackBar("Upload failed: $e", Icons.error, Colors.red);
    } finally {
      setState(() => _isUploading = false);
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

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: showSearch
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search users or groups...',
                  border: InputBorder.none,
                ),
                onChanged: (value) =>
                    setState(() => searchQuery = value.trim().toLowerCase()),
              )
            : const Text("Chat App"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(showSearch ? Icons.close : Icons.search),
            onPressed: toggleSearch,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildChatList(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // FIXED: Real-time name display from Firestore
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Usersstore")
                .doc(currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              // Default values
              String displayName = "Loading...";
              String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No email';
              String avatarText = "U";
              String? photoUrl;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildDrawerHeader(
                  displayName: "Loading...",
                  userEmail: userEmail,
                  avatarText: "...",
                  photoUrl: null,
                );
              }

              if (snapshot.hasError) {
                return _buildDrawerHeader(
                  displayName: "Error loading",
                  userEmail: userEmail,
                  avatarText: "!",
                  photoUrl: null,
                );
              }

              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final name = data?['name'] as String?;
                photoUrl = data?['photoUrl'] as String?;
                
                // ✅ CRITICAL FIX: Use name if exists, otherwise use email
                if (name != null && name.isNotEmpty) {
                  displayName = name;
                  avatarText = name[0].toUpperCase();
                } else {
                  displayName = userEmail;
                  avatarText = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'U';
                }
              } else {
                // No data in Firestore yet
                displayName = userEmail;
                avatarText = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'U';
              }

              return _buildDrawerHeader(
                displayName: displayName,
                userEmail: userEmail,
                avatarText: avatarText,
                photoUrl: photoUrl,
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Change profile name"),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const Profilename())
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text("Create New Group"),
            onTap: _showCreateGroupDialog,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await _authService.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Homepages()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader({
    required String displayName,
    required String userEmail,
    required String avatarText,
    required String? photoUrl,
  }) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
      ),
      accountName: Text(
        displayName,
        style: const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      accountEmail: Text(
        userEmail,
        style: const TextStyle(color: Colors.white70),
      ),
      currentAccountPicture: GestureDetector(
        onTap: _isUploading ? null : _pickAndUploadProfilePhoto,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 38,
                backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) 
                    ? NetworkImage(photoUrl) 
                    : null,
                child: (photoUrl == null || photoUrl.isEmpty)
                    ? Text(
                        avatarText,
                        style: const TextStyle(
                          fontSize: 24, 
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
            if (_isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chattservices.getUserGroups(currentUserId!),
      builder: (context, groupSnapshot) {
        if (groupSnapshot.hasError) {
          return Center(child: Text('Error: ${groupSnapshot.error}'));
        }

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chattservices.getUserStream(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasError) {
              return Center(child: Text('Error: ${userSnapshot.error}'));
            }

            if (!groupSnapshot.hasData || !userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final groups = groupSnapshot.data!
                .where((g) => searchQuery.isEmpty ||
                    (g['name']?.toString().toLowerCase() ?? '')
                        .contains(searchQuery))
                .toList();

            final users = userSnapshot.data!
                .where((u) => u['userid'] != currentUserId)
                .where((u) => searchQuery.isEmpty ||
                    (u['email']?.toString().toLowerCase() ?? '')
                        .contains(searchQuery))
                .toList();

            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (groups.isNotEmpty) 
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Groups",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ...groups.map(_buildGroupTile),
                
                if (groups.isNotEmpty && users.isNotEmpty)
                  const Divider(),
                
                if (users.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Users",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ...users.map(_buildUserTile),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGroupTile(Map<String, dynamic> group) {
    final groupId = group['groupId'] as String?;
    final groupName = group['name'] as String? ?? 'Unnamed Group';
    return ListTile(
      leading: const Icon(Icons.group, color: Colors.orange, size: 30),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: () {
        if (groupId != null && groupId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GroupChatPage(
                groupId: groupId,
                groupName: groupName,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final receiverId = user['userid'] as String? ?? '';
    final email = user['email'] as String? ?? '';
    final photoUrl = user['photoUrl'] as String?;
    final nickname = user['name'] as String?;

    // ✅ FIXED: Use name if available, otherwise use email
    final displayName = nickname ?? email;
    final initial = (displayName.isNotEmpty ? displayName[0] : '?').toUpperCase();

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blue.shade100,
        backgroundImage:
            (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
        child: (photoUrl == null || photoUrl.isEmpty)
            ? Text(
                initial,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            : null,
      ),
      title: Text(
        displayName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: nickname != null ? Text(email) : null,
      onTap: () {
        if (receiverId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChattMessage(
                receiverEmail: email,
                receiverId: receiverId,
              ),
            ),
          );
        }
      },
    );
  }

  void _showCreateGroupDialog() {
    final groupNameController = TextEditingController();
    List<String> selectedUserIds = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Create New Group"),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: groupNameController,
                  decoration: const InputDecoration(
                    hintText: "Group Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Select members:"),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _chattservices.getUserStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final users = snapshot.data!
                          .where((u) => u['userid'] != currentUserId)
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final userId = user['userid'] as String? ?? '';
                          final email = user['email'] as String? ?? 'Unknown';
                          final name = user['name'] as String?;
                          final displayName = name ?? email;
                          final isSelected = selectedUserIds.contains(userId);

                          return ListTile(
                            title: Text(displayName),
                            subtitle: name != null ? Text(email) : null,
                            trailing: Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            onTap: () => setState(() {
                              if (isSelected) {
                                selectedUserIds.remove(userId);
                              } else {
                                selectedUserIds.add(userId);
                              }
                            }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final groupName = groupNameController.text.trim();
                if (groupName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a group name"),
                    ),
                  );
                  return;
                }

                if (selectedUserIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least one member"),
                    ),
                  );
                  return;
                }

                selectedUserIds.add(currentUserId!);
                String groupId = await _chattservices.createGroup(
                  groupName,
                  selectedUserIds,
                );

                if (!mounted) return;
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChatPage(
                      groupId: groupId,
                      groupName: groupName,
                    ),
                  ),
                );
              },
              child: const Text("Create Group"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              "Use this as profile photo?",
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
                  child: Text("CANCEL", style: TextStyle(color: Colors.grey[600])),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("USE", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}