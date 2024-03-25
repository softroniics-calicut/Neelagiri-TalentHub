import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class CustomAcceptRejectButton extends StatelessWidget {
  final String acceptText;
  final String rejectText;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool rejectButtonEnabled; // Add this

  const CustomAcceptRejectButton({
    Key? key,
    required this.acceptText,
    required this.rejectText,
    required this.onAccept,
    required this.onReject,
    required this.rejectButtonEnabled, // Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onAccept,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: CustomText(
            text: acceptText,
            size: 16,
            weight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: rejectButtonEnabled
              ? onReject
              : null, // Conditionally disable reject button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: CustomText(
            text: rejectText,
            weight: FontWeight.normal,
            size: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CollegAcceptStudent extends StatefulWidget {
  const CollegAcceptStudent({Key? key}) : super(key: key);

  @override
  State<CollegAcceptStudent> createState() => _CollegAcceptStudentState();
}

class _CollegAcceptStudentState extends State<CollegAcceptStudent> {
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String? currentCollege = currentUser?.displayName;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('college', isEqualTo: currentCollege)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
    );
  }

  Widget buildStudentCard(Map<String, dynamic> userData) {
    bool isAccepted = userData['status'] == 'Accepted';

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
                const SizedBox(height: 16),
                CustomAcceptRejectButton(
                  acceptText: 'Accept',
                  rejectText: 'Reject',
                  onAccept: () {
                    // Handle accept action
                    updateStatus(userData['userId'], 'Accepted');
                  },
                  onReject: () {
                    // Handle reject action
                    updateStatus(userData['userId'], 'Rejected');
                  },
                  // Disable the reject button if status is accepted
                  rejectButtonEnabled: !isAccepted,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: 'Status: ${userData['status'] ?? 'Pending'}',
                  size: 16,
                  color: Colors.black,
                  weight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateStatus(String userId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'status': status});
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
