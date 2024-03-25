import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class AdminviewCollege extends StatelessWidget {
  const AdminviewCollege({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('college').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final colleges = snapshot.data!.docs;
            if (colleges.isEmpty) {
              return Center(child: Text('No colleges found'));
            }
            return ListView.builder(
              itemCount: colleges.length,
              itemBuilder: (context, index) {
                final collegeData =
                    colleges[index].data() as Map<String, dynamic>;
                return CollegeCard(
                  collegeName: collegeData['name'] ?? '',
                  email: collegeData['email'] ?? '',
                  phoneNumber: collegeData['phoneNumber'] ?? '',
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CollegeCard extends StatelessWidget {
  final String collegeName;
  final String email;
  final String phoneNumber;

  const CollegeCard({
    Key? key,
    required this.collegeName,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      child: Card(
        color: Color(0xFF67B0DA),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: collegeName,
                size: 20,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'Email: $email',
                size: 16,
                color: Colors.white,
                weight: FontWeight.normal,
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'Phone Number: $phoneNumber',
                size: 16,
                color: Colors.white,
                weight: FontWeight.normal,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
