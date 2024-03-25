import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/view/district%20coordinator/dist_forgotpassword.dart';
import 'package:talenthub/src/view/district%20coordinator/dist_signup.dart';
import 'package:talenthub/src/view/district%20coordinator/distbottom.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class DistrictLogin extends StatefulWidget {
  const DistrictLogin({Key? key}) : super(key: key);

  @override
  State<DistrictLogin> createState() => _DistrictLoginState();
}

class _DistrictLoginState extends State<DistrictLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveUserIdToSharedPreferences(String districtId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('districtId', districtId);
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
                        .collection('District-coordinator')
                        .where('email', isEqualTo: email)
                        .limit(1)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      var userData = querySnapshot.docs.first.data();
                      if (userData['password'] != null &&
                          userData['password'] == password) {
                        await _saveUserIdToSharedPreferences(
                            userData['districtId'] ?? '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DistBottomNavigation(),
                          ),
                        );
                      } else {
                        _showToast('Incorrect password');
                      }
                    } else {
                      _showToast('User not found');
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
                          builder: (context) => const DistForgotPassword(),
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
                          builder: (context) => Dist_SignUp(),
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
