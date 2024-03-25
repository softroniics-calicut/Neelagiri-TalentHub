import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class AdminCoordinatorView extends StatefulWidget {
  const AdminCoordinatorView({super.key});

  @override
  State<AdminCoordinatorView> createState() => _AdminCoordinatorViewState();
}

class _AdminCoordinatorViewState extends State<AdminCoordinatorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('District-coordinator')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final storekeepers = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: storekeepers.length,
            itemBuilder: (context, index) {
              final storekeeperData =
                  storekeepers[index].data() as Map<String, dynamic>;
              final storekeeperName = storekeeperData['name'] ?? '';
              final email = storekeeperData['email'] ?? '';
              final phoneNumber = storekeeperData['phoneNumber'] ?? '';
              final status = storekeeperData['status'] ?? '';
              final isAccepted = status == 'Accepted';
              return _buildCard(
                storekeeperName,
                email,
                phoneNumber,
                status,
                isAccepted,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(String storekeeperName, String email, String phoneNumber,
      String status, bool isAccepted) {
    return Card(
      color: Color(0xFF67B0DA),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: storekeeperName,
              size: 18,
              color: Colors.black,
              weight: FontWeight.normal,
            ),
            SizedBox(height: 8),
            CustomText(
              text: 'Email: $email',
              size: 16,
              color: Colors.black,
              weight: FontWeight.normal,
            ),
            SizedBox(height: 8),
            CustomText(
              text: 'Phone Number: $phoneNumber',
              size: 16,
              color: Colors.black,
              weight: FontWeight.normal,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                    text: 'Accept',
                    onPressed: isAccepted
                        ? () {}
                        : () {
                            _updateStatus(email, 'Accepted');
                          },
                    color: isAccepted
                        ? const Color.fromARGB(255, 37, 143, 40)
                        : Color.fromARGB(255, 37, 143, 40)),
                CustomButton(
                  text: 'Reject',
                  onPressed: isAccepted
                      ? () {}
                      : () {
                          _updateStatus(email, 'Rejected');
                        },
                  color: isAccepted ? Colors.grey : Colors.red,
                ),
              ],
            ),
            SizedBox(height: 8),
            CustomText(
              text: 'Satus: $status',
              size: 16,
              color: Colors.red,
              weight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String email, String status) {
    FirebaseFirestore.instance
        .collection('District-coordinator')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        document.reference.update({'status': status});
      }
    });
  }
}
