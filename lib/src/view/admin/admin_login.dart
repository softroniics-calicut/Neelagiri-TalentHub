import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talenthub/src/view/admin/admin_bottomnavigation.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

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
                  text: 'Login',
                  size: 30,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
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
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          var querySnapshot = await FirebaseFirestore.instance
                              .collection('admin')
                              .where('email', isEqualTo: email)
                              .limit(1)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            var userData = querySnapshot.docs.first.data();
                            if (userData['password'] == password) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminBottomNavigation(),
                                ),
                              );

                              Fluttertoast.showToast(
                                msg: 'Successfully logged in as admin!',
                                backgroundColor: Colors.green,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Incorrect password!',
                                backgroundColor: Colors.red,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'User not found!',
                              backgroundColor: Colors.red,
                            );
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67B0DA),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CustomText(
                          text: 'Login',
                          size: 16,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
