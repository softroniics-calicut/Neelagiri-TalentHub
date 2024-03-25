import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/college/collegelogin.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class CollegeSignUp extends StatefulWidget {
  final String collegeId;

  const CollegeSignUp({
    Key? key,
    required this.collegeId,
  }) : super(key: key);

  @override
  _CollegeSignUpState createState() => _CollegeSignUpState();
}

class _CollegeSignUpState extends State<CollegeSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    try {
      String email = emailController.text.trim(); // Trim any whitespace
      if (email.isEmpty) {
        print('Email is empty!');
        return; // Return early if email is empty
      }

      // Generate a shorter custom document ID for the user
      String userId = generateShortId(6);
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      if ((await userRef.get()).exists) {
        print('User already exists!');
        return;
      }

      // Add user data to Firestore
      await userRef.set({
        'collegeId': widget.collegeId, // Associate user with college
        'name': nameController.text,
        'email': email,
        'phoneNumber': phoneNumberController.text,
        'password': passwordController.text,
      });
      print('User data added to Firestore successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CollegeLogin(),
        ),
      );
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle any errors that occur during the registration process
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
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Name',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Phone Number',
                controller: phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Password',
                obscureText: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate form inputs before registration
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67B0DA),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
