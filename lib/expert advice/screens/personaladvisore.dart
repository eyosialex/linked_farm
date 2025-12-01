import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:echat/chattpage/chattservices.dart';
import 'package:echat/chattpage/chattmessage.dart';

class AdvisorListPage extends StatefulWidget {
  const AdvisorListPage({super.key});

  @override
  State<AdvisorListPage> createState() => _AdvisorListPageState();
}

class _AdvisorListPageState extends State<AdvisorListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Chattservices _chatService = Chattservices();
  
  List<Map<String, dynamic>> _advisors = [];
  List<Map<String, dynamic>> _filteredAdvisors = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAdvisors();
  }

  Future<void> _loadAdvisors() async {
    try {
      final querySnapshot = await _firestore
          .collection('Usersstore')
          .where('userType', isEqualTo: 'advisor')
          .where('profileCompleted', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> advisors = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        advisors.add({
          'userid': doc.id,
          'email': data['email'] ?? '',
          'fullName': data['fullName'] ?? 'Unknown Advisor',
          'universityGraduated': data['universityGraduated'] ?? 'Not specified',
          'degreeLevel': data['degreeLevel'] ?? 'Not specified',
          'experience': data['experience'] ?? 'Not specified',
          'focusArea': data['focusArea'] ?? 'General Agriculture',
          'currentlyWork': data['currentlyWork'] ?? 'Not specified',
          'address': data['address'] ?? 'Not specified',
          'rating': data['rating'] ?? 4.5,
          'studentsHelped': data['studentsHelped'] ?? 0,
          'isOnline': data['isOnline'] ?? false,
          'lastseen': data['lastseen'],
          'photoUrl': data['photoUrl'] ?? '',
        });
      }

      setState(() {
        _advisors = advisors;
        _filteredAdvisors = advisors;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading advisors: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterAdvisors() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredAdvisors = _advisors;
      });
      return;
    }

    final filtered = _advisors.where((advisor) {
      final name = advisor['fullName'].toString().toLowerCase();
      final specialization = advisor['focusArea'].toString().toLowerCase();
      final university = advisor['universityGraduated'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      
      return name.contains(query) || 
             specialization.contains(query) || 
             university.contains(query);
    }).toList();

    setState(() {
      _filteredAdvisors = filtered;
    });
  }

  Future<void> _connectWithAdvisor(Map<String, dynamic> advisor) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _chatService.sendmessage(
        advisor['userid'], 
        "Hello! I'm interested in getting your expert advice on agricultural matters. I found you through the advisor directory."
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChattMessage(
            receiverEmail: advisor['email'],
            receiverId: advisor['userid'],
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connected with advisor successfully!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('Error connecting with advisor: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAdvisorCard(Map<String, dynamic> advisor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and basic info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[100],
                  backgroundImage: advisor['photoUrl'] != null && advisor['photoUrl'].isNotEmpty
                      ? NetworkImage(advisor['photoUrl'])
                      : null,
                  child: advisor['photoUrl'] == null || advisor['photoUrl'].isEmpty
                      ? Icon(Icons.school, color: Colors.green[700])
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advisor['fullName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        advisor['degreeLevel'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Online status and rating
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      backgroundColor: Colors.green[50],
                      label: Text(
                        '⭐ ${advisor['rating']}',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: advisor['isOnline'] == true ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          advisor['isOnline'] == true ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: advisor['isOnline'] == true ? Colors.green : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Professional information
            _buildInfoRow('🎓', advisor['universityGraduated']),
            _buildInfoRow('🏢', advisor['currentlyWork']),
            _buildInfoRow('📍', advisor['address']),
            _buildInfoRow('⏱️', '${advisor['experience']} experience'),
            
            const SizedBox(height: 8),
            
            // Specialization badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Specialization: ${advisor['focusArea']}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Connect button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _connectWithAdvisor(advisor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat, size: 20),
                    SizedBox(width: 8),
                    Text('Connect for Advice'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search advisors by name, specialization...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _filterAdvisors();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Advisors'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: _filteredAdvisors.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No advisors found',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              Text(
                                'Try adjusting your search criteria',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredAdvisors.length,
                          itemBuilder: (context, index) {
                            return _buildAdvisorCard(_filteredAdvisors[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}