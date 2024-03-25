import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/models/landing%20page.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _collegeController;
  late TextEditingController _departmentController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _collegeController = TextEditingController();
    _departmentController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        _nameController.text = userSnapshot['name'] ?? '';
        _emailController.text = userSnapshot['email'] ?? '';
        _phoneNumberController.text = userSnapshot['phoneNumber'] ?? '';
        _collegeController.text = userSnapshot['college'] ?? '';
        _departmentController.text = userSnapshot['department'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF67B0DA),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LandingPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/person.jpg'),
              ),
              SizedBox(height: 20),
              DataTable(
                columnSpacing: 20.0,
                dataRowHeight: 50.0,
                columns: [
                  DataColumn(
                    label: SizedBox.shrink(),
                  ),
                  DataColumn(
                    label: SizedBox.shrink(),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(CustomText(
                      text: 'Name',
                      weight: FontWeight.bold,
                      color: Colors.black,
                      size: 15,
                    )),
                    DataCell(TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(CustomText(
                      text: 'Email',
                      weight: FontWeight.bold,
                      color: Colors.black,
                      size: 15,
                    )),
                    DataCell(TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(CustomText(
                      text: 'College',
                      weight: FontWeight.bold,
                      color: Colors.black,
                      size: 15,
                    )),
                    DataCell(TextFormField(
                      controller: _collegeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(CustomText(
                      text: 'Department',
                      weight: FontWeight.bold,
                      color: Colors.black,
                      size: 15,
                    )),
                    DataCell(TextFormField(
                      controller: _departmentController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(CustomText(
                      text: 'Phone Number',
                      weight: FontWeight.bold,
                      color: Colors.black,
                      size: 15,
                    )),
                    DataCell(TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const CustomText(
                  text: 'Edit Profile',
                  weight: FontWeight.bold,
                  color: Colors.black,
                  size: 15,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                      ),
                      TextFormField(
                        controller: _collegeController,
                        decoration:
                            const InputDecoration(labelText: 'College names'),
                      ),
                      TextFormField(
                        controller: _departmentController,
                        decoration:
                            const InputDecoration(labelText: 'Department'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? userId = prefs.getString('userId');

                      if (userId != null) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'phoneNumber': _phoneNumberController.text,
                          'college': _collegeController.text,
                          'department': _departmentController.text,
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Profile updated successfully'),
                            duration: Duration(seconds: 2),
                          ));
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to update profile: $error'),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.edit),
        backgroundColor: const Color(0xFF67B0DA),
      ),
    );
  }
}
