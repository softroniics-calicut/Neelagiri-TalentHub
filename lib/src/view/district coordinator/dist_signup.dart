import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/district%20coordinator/dist_login.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class Dist_SignUp extends StatefulWidget {
  Dist_SignUp({Key? key}) : super(key: key);

  @override
  _Dist_SignUpState createState() => _Dist_SignUpState();
}

class _Dist_SignUpState extends State<Dist_SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser(BuildContext context) async {
    try {
      // Validate form inputs
      if (!_formKey.currentState!.validate()) {
        return;
      }

      String email = emailController.text.trim();
      String password = passwordController.text;

      String districtId = generateShortId(6);

      CollectionReference districtCollection =
          FirebaseFirestore.instance.collection('District-coordinator');

      QuerySnapshot querySnapshot = await districtCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('User already exists with this email!');
        return;
      }

      await districtCollection.doc(districtId).set({
        'districtId': districtId,
        'name': nameController.text,
        'email': email,
        'phoneNumber': phoneNumberController.text,
        'password': password,
      });

      print('User data added to Firestore successfully!');
      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DistrictLogin(),
        ),
      );
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CustomText(
                  text: 'Sign Up',
                  size: 30,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: phoneNumberController,
                labelText: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF67B0DA),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomText(
                    text: 'Sign Up',
                    size: 16,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateShortId(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }
}
