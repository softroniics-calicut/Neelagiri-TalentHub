import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/user/user%20reset%20pssword.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class UserForgotPassword extends StatefulWidget {
  const UserForgotPassword({Key? key}) : super(key: key);

  @override
  State<UserForgotPassword> createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: email,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                labelText: 'Email',
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? true) {
                      bool emailExists = await checkEmailExists(email.text);
                      if (emailExists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                UserResetPassword(email: email.text),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CustomText(
                              text: 'Email does not exist',
                              size: 14,
                              weight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  text: 'Next',
                  color: Color(0xFF67B0DA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }
}
