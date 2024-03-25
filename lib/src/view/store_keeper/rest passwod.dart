import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/store_keeper/storekeeperlogin.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class StoreResetPassword extends StatefulWidget {
  String email;
  StoreResetPassword({Key? key, required this.email});

  @override
  State<StoreResetPassword> createState() => _StoreResetPasswordState();
}

class _StoreResetPasswordState extends State<StoreResetPassword> {
  var password = TextEditingController();
  var cpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            size: 20,
            weight: FontWeight.w500,
            color: Colors.black,
            text: 'Reset Password',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 20),
            child: CustomTextField(
              controller: password,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter new password';
                }
                return null;
              },
              labelText: 'Password',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 45, right: 20),
            child: CustomTextField(
              controller: cpassword,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter password';
                }
                return null;
              },
              labelText: 'Confirm Password',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomButton(
              onPressed: () async {
                if (cpassword.text == password.text) {
                  print('equal');
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('storekeeper')
                      .where('email', isEqualTo: widget.email)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    DocumentReference userDocRef =
                        querySnapshot.docs.first.reference;
                    await userDocRef.update({
                      'password': password.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomText(
                          color: Colors.green,
                          text: "Password updated",
                          size: 14,
                          weight: FontWeight.normal,
                        ),
                      ),
                    );

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StoreKeeperLogin(),
                      ),
                    );
                  } else {
                    // Handle case where no documents match the query
                    print('No user found with the provided email.');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomText(
                        text: "Passwords don't match",
                        size: 14,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  );
                  print('not equal');
                }
              },
              text: 'Done',
              color: const Color(0xFF67B0DA),
            ),
          ),
        ],
      ),
    );
  }
}
