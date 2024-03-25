import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class CollgeForgotPassword extends StatelessWidget {
  const CollgeForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: 'Forgot Password',
              size: 30,
              weight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            CustomText(
              text: 'Enter your email address to reset your password.',
              size: 16,
              weight: FontWeight.normal,
              color: Colors.grey,
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
            ElevatedButton(
              onPressed: () {
                _resetPassword(context, emailController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF67B0DA),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomText(
                  text: 'Reset Password',
                  size: 16,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message or navigate to a success screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent to $email'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
