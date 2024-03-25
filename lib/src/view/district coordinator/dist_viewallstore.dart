import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class DistViewAllCoordinator extends StatefulWidget {
  const DistViewAllCoordinator({Key? key}) : super(key: key);

  @override
  State<DistViewAllCoordinator> createState() => _DistViewAllCoordinatorState();
}

class _DistViewAllCoordinatorState extends State<DistViewAllCoordinator> {
  late Stream<QuerySnapshot> _storekeeperStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen for changes in the storekeeper collection
    _storekeeperStream =
        FirebaseFirestore.instance.collection('storekeeper').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF67B0DA),
        title: CustomText(
          text: 'All Storekeeper View',
          size: 20,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _storekeeperStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: CustomText(
                  text: 'Error: ${snapshot.error}',
                  size: 16,
                  color: Colors.red,
                  weight: FontWeight.bold,
                ),
              );
            }
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // Extracting data from each document in the snapshot
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String coordinatorName = data['name'] ?? 'Unknown';
                  String email = data['email'] ?? 'Unknown';
                  String phoneNumber = data['phoneNumber'] ?? 'Unknown';
                  String status = data['status'] ?? 'Pending';

                  return Container(
                    width: double.maxFinite,
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
                              text: coordinatorName,
                              size: 20,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Email: ${email ?? 'Unknown'}',
                              size: 16,
                              color: Colors.white,
                              weight: FontWeight.normal,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Phone number: ${phoneNumber ?? 'Unknown'}',
                              size: 16,
                              color: Colors.white,
                              weight: FontWeight.normal,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Status: ${status ?? 'Pending'}',
                              size: 12,
                              color: Colors.black,
                              weight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CustomText(
                  text: 'No storekeepers found.',
                  size: 16,
                  color: Colors.black,
                  weight: FontWeight.bold,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
