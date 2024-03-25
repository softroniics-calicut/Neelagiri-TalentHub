import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/store_keeper/rest%20passwod.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class StoreForgotPassword extends StatefulWidget {
  const StoreForgotPassword({Key? key}) : super(key: key);

  @override
  State<StoreForgotPassword> createState() => _StoreForgotPasswordState();
}

class _StoreForgotPasswordState extends State<StoreForgotPassword> {
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
                                StoreResetPassword(email: email.text),
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
      // Query Firestore collection "storekeeper" for the provided email
      var querySnapshot = await FirebaseFirestore.instance
          .collection('storekeeper')
          .where('email', isEqualTo: email)
          .get();
      // Check if any documents match the provided email
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }
}
