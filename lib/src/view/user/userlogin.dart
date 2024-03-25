import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/view/user/user_bottom_navigation.dart';
import 'package:talenthub/src/view/user/user_forgotpassword.dart';
import 'package:talenthub/src/view/user/user_signup.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _saveUserIdToSharedPreferences(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 48, 46, 46),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center the form
        child: SingleChildScrollView(
          child: Padding(
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
                        return 'Please enter your email';
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();
                              var querySnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .where('email', isEqualTo: email)
                                  .where('status', isEqualTo: 'Accepted')
                                  .limit(1)
                                  .get();

                              setState(() {
                                _isLoading = false;
                              });

                              if (querySnapshot.docs.isNotEmpty) {
                                var userData = querySnapshot.docs.first.data();
                                if (userData['password'] == password) {
                                  await _saveUserIdToSharedPreferences(
                                      userData['userId']);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserBottomNavigation(),
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Incorrect password',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'User not found',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF67B0DA),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CustomText(
                              text: 'Login',
                              size: 16,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserForgotPassword(),
                            ),
                          );
                        },
                        child: const CustomText(
                          text: 'Forgot Password?',
                          size: 14,
                          weight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Don't have an account?",
                        size: 14,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserSignUp(),
                            ),
                          );
                        },
                        child: const CustomText(
                          text: 'Sign Up',
                          size: 14,
                          weight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
