
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/chattpage/chattservices.dart';
import 'package:flutter/material.dart';


import 'groupmessage.dart';

class GroupsPage extends StatelessWidget {
  final Chattservices _chattservices = Chattservices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Groups")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Groups").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final groups = snapshot.data!.docs;

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var group = groups[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(group['groupName']),
                subtitle: Text("Members: ${group['members'].length}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupChatPage(
                        groupId: groups[index].id,
                        groupName: group['groupName'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
