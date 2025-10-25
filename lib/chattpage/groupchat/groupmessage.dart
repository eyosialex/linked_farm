
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/chattpage/chattservices.dart';
import 'package:flutter/material.dart';
class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  const GroupChatPage({super.key, required this.groupId, required this.groupName});
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController messageController = TextEditingController();
  final Chattservices _chattservices = Chattservices();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      _chattservices.sendGroupMessage(widget.groupId, messageController.text.trim());
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chattservices.getGroupMessages(widget.groupId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['senderEmail']),
                      subtitle: Text(data['message']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(controller: messageController, decoration: InputDecoration(hintText: "Type message")),
              ),
              IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
            ],
          )
        ],
      ),
    );
  }
}
