import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/Advisor%20View/advice_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyArticlesScreen extends StatelessWidget {
  const MyArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Articles"),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('advice_posts')
            .where('authorId', isEqualTo: currentUserId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books_sharp, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("You haven't posted any articles yet.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final advice = AdviceModel.fromFirestore(doc);
              return _buildArticleTile(context, advice);
            },
          );
        },
      ),
    );
  }

  Widget _buildArticleTile(BuildContext context, AdviceModel advice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(advice.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${advice.category} • ${DateFormat('MMM dd, yyyy').format(advice.timestamp)}",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // You could reuse the detail sheet or create a full page
          _showDeleteConfirmation(context, advice.id);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String adviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Article Options"),
        content: const Text("Would you like to delete this article?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('advice_posts').doc(adviceId).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Article deleted")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
