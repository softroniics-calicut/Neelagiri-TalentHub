import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/store_keeper/storekeeperlogin.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class StorekeeperSignUp extends StatelessWidget {
  StorekeeperSignUp({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  // You can add more specific email validation if needed
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
                  // You can add more specific phone number validation if needed
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
                  // You can add more specific password validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Validate the form before proceeding
                  if (_formKey.currentState!.validate()) {
                    // Add your sign up logic here
                    _registerUser(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67B0DA),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
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

  Future<void> _registerUser(BuildContext context) async {
    try {
      String email = emailController.text.trim(); // Trim any whitespace
      if (email.isEmpty) {
        print('Email is empty!');
        return; // Return early if email is empty
      }

      // Generate a shorter custom document ID
      String userId = generateShortId(6);
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('storekeeper').doc(userId);

      if ((await userRef.get()).exists) {
        print('Store keeper already exists!');
        return;
      }

      await userRef.set({
        'storeId': userId,
        'name': nameController.text,
        'email': email,
        'phoneNumber': phoneNumberController.text,
        'password': passwordController.text,
      });
      print('Store keeper data added to Firestore successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StoreKeeperLogin(),
        ),
      );
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle any errors that occur during the registration process
      // Show a snackbar or dialog to inform the user about the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign up. Please try again later.'),
        ),
      );
    }
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
