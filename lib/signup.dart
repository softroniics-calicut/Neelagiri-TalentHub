import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class StoreKeeperSignup extends StatefulWidget {
  const StoreKeeperSignup({Key? key}) : super(key: key);

  @override
  _StoreKeeperSignupState createState() => _StoreKeeperSignupState();
}

class _StoreKeeperSignupState extends State<StoreKeeperSignup> {
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

  Future<void> _registerUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        // You might want to hash the password before storing it in Firestore for security
        // 'password': passwordController.text,
      });
      print('User data added to Firestore successfully!');
      // Navigate to the login screen after successful sign up
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const UserLogin(),
      //   ),
      // );
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle any errors that occur during the Firestore operation
      // You can display an error message to the user if needed
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
}
