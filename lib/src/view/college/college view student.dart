import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class CollegViewStudent extends StatefulWidget {
  const CollegViewStudent({Key? key});

  @override
  State<CollegViewStudent> createState() => _CollegViewStudentState();
}

class _CollegViewStudentState extends State<CollegViewStudent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userData = users[index].data() as Map<String, dynamic>;
                  return buildStudentCard(userData);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildStudentCard(Map<String, dynamic> userData) {
    return IntrinsicWidth(
      child: Container(
        child: Card(
          color: const Color(0xFF67B0DA),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: userData['name'] ?? 'No Name',
                  size: 20,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: 'Email: ${userData['email'] ?? 'No Email'}',
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.normal,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: 'College: ${userData['college'] ?? 'No College'}',
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.normal,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text:
                      'Department: ${userData['department'] ?? 'No Department'}',
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.normal,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: 'Phone: ${userData['phoneNumber'] ?? 'No Phone'}',
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
