import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/user/userlogin.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    collegeController.dispose();
    departmentController.dispose();
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

      // Generate a shorter custom document ID
      String userId = generateShortId(6);
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      if ((await userRef.get()).exists) {
        print('User already exists!');
        return;
      }
      if ((await userRef.get()).exists) {
        print('User already exists!');
        return;
      }
      await userRef.set({
        'userId': userId,
        'name': nameController.text,
        'email': email,
        'phoneNumber': phoneNumberController.text,
        'college': collegeController.text,
        'department': departmentController.text,
        'password': passwordController.text,
      });
      print('User data added to Firestore successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserLogin(),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
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
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  // keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'College Name',
                  controller: collegeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your College';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Department',
                  controller: departmentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your department';
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
                      return 'Please enter your password';
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
      ),
    );
  }
}

String generateShortId(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
