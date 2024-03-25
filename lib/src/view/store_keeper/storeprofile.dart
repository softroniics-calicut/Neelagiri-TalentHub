import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/models/landing%20page.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class StoreProfile extends StatefulWidget {
  const StoreProfile({Key? key}) : super(key: key);

  @override
  State<StoreProfile> createState() => _StoreProfileState();
}

class _StoreProfileState extends State<StoreProfile> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeId = prefs.getString('storeId');

    if (storeId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('storekeeper')
          .doc(storeId)
          .get();

      setState(() {
        _nameController.text = userSnapshot['name'] ?? '';
        _emailController.text = userSnapshot['email'] ?? '';
        _phoneNumberController.text = userSnapshot['phoneNumber'] ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeId = prefs.getString('storeId');

    if (storeId != null) {
      await FirebaseFirestore.instance
          .collection('storekeeper')
          .doc(storeId)
          .update({
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
      }).then((value) {
        print('User data updated successfully');
      }).catchError((error) {
        print('Failed to update user data: $error');
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
                      await _updateUserData();
                      Navigator.of(context).pop();
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
