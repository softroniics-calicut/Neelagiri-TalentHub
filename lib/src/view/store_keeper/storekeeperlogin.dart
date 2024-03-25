import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/view/store_keeper/storebottom.dart';
import 'package:talenthub/src/view/store_keeper/storekeeperforgotpassword.dart';
import 'package:talenthub/src/view/user/user_signup.dart';
import 'package:talenthub/src/widget/custom_text.dart';
import 'package:talenthub/src/widget/custom_textfield.dart';

class StoreKeeperLogin extends StatelessWidget {
  const StoreKeeperLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> _saveStoreIdToSharedPreferences(String storeId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('storeId', storeId);
    }

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
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    var querySnapshot = await FirebaseFirestore.instance
                        .collection('storekeeper')
                        .where('email', isEqualTo: email)
                        .limit(1)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      var userData = querySnapshot.docs.first.data();
                      if (userData['password'] == password) {
                        await _saveStoreIdToSharedPreferences(
                            userData['storeId']);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreBottomNavigation(),
                          ),
                        );
                      } else {
                        print('Incorrect password');
                      }
                    } else {
                      print('User not found');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67B0DA),
                ),
                child: const Padding(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoreForgotPassword(),
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
    );
  }
}
