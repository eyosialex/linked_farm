import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedfarm/Services/chat_service.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _groupNameController = TextEditingController();
  final List<String> _selectedMemberIds = [];
  String _searchQuery = "";
  bool _isChannel = false; // Choose between group or channel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isChannel ? "New Channel" : "New Group"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _createGroup,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    labelText: _isChannel ? "Channel Name" : "Group Name",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text("Create as Channel"),
                  subtitle: const Text("Only admins can post in channels"),
                  value: _isChannel,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => _isChannel = val),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search members...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.searchUsers(_searchQuery),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    bool isSelected = _selectedMemberIds.contains(user.id);
                    return CheckboxListTile(
                      title: Text(user['fullName']),
                      subtitle: Text(user['userType']),
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedMemberIds.add(user.id);
                          } else {
                            _selectedMemberIds.remove(user.id);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createGroup() async {
    if (_groupNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a ${_isChannel ? 'channel' : 'group'} name")));
      return;
    }
    
    await _chatService.createGroup(
      _groupNameController.text, 
      _selectedMemberIds,
      type: _isChannel ? 'channel' : 'group',
    );
    Navigator.pop(context);
  }
}
