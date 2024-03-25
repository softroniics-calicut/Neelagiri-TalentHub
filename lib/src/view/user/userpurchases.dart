import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:talenthub/src/view/user/user_home.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class UserPurchaseSuccessful extends StatefulWidget {
  const UserPurchaseSuccessful({Key? key}) : super(key: key);

  @override
  State<UserPurchaseSuccessful> createState() => _UserPurchaseSuccessfulState();
}

class _UserPurchaseSuccessfulState extends State<UserPurchaseSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 150,
                child: Lottie.asset(
                  'assets/purchase successful.json',
                  width: 130,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Order Verified",
                weight: FontWeight.normal,
                color: Colors.black,
                size: 15,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Come to pick orders",
                weight: FontWeight.normal,
                color: Colors.black,
                size: 15,
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff4D6877),
                ),
                child: CustomButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const UserHome();
                      },
                    ));
                  },
                  text: 'Continue Shopping',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
