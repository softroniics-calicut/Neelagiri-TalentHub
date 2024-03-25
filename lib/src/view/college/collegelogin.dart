import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/view/college/college%20forgotpassword.dart';
import 'package:talenthub/src/view/college/collegebottom.dart';
import 'package:talenthub/src/view/college/collegesignup.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class CollegeLogin extends StatefulWidget {
  const CollegeLogin({Key? key}) : super(key: key);

  @override
  State<CollegeLogin> createState() => _CollegeLoginState();
}

class _CollegeLoginState extends State<CollegeLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveUserIdToSharedPreferences(String collegeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('collegeId', collegeId);
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    var querySnapshot = await FirebaseFirestore.instance
                        .collection('college')
                        .where('email', isEqualTo: email)
                        .limit(1)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      var userData = querySnapshot.docs.first.data();
                      if (userData['password'] == password) {
                        await _saveUserIdToSharedPreferences(
                            userData['collegeId']);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CollegeBottomNavigation(),
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
                          builder: (context) => const CollgeForgotPassword(),
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
                          builder: (context) => const CollegeSignUp(
                            collegeId: '',
                          ),
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
    );
  }
}
