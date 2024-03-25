import 'package:flutter/material.dart';
import 'package:talenthub/src/view/admin/admin_login.dart';
import 'package:talenthub/src/view/college/collegelogin.dart';
import 'package:talenthub/src/view/district%20coordinator/dist_login.dart';
import 'package:talenthub/src/view/store_keeper/storekeeperlogin.dart';
import 'package:talenthub/src/view/user/userlogin.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF67B0DA),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLogin(),
                ),
              );
            },
            child: CustomText(
              text: 'Admin',
              size: 16,
              weight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                text: 'Welcome',
                size: 30,
                weight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Select User Type',
                size: 20,
                weight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  userTypeOption(context, 'User', screenWidth),
                  const SizedBox(height: 15),
                  userTypeOption(context, 'Store keeper', screenWidth),
                  const SizedBox(height: 15),
                  userTypeOption(context, 'College', screenWidth),
                  const SizedBox(height: 15),
                  userTypeOption(context, 'District Coordinator', screenWidth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userTypeOption(
      BuildContext context, String userType, double screenWidth) {
    return InkWell(
      onTap: () {
        // Add navigation logic for each user type
        switch (userType) {
          case 'User':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserLogin(),
              ),
            );
            break;
          case 'Store keeper':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StoreKeeperLogin(),
              ),
            );
            break;
          case 'College':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CollegeLogin(),
              ),
            );
            break;
          case 'District Coordinator':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DistrictLogin(),
              ),
            );
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFCFE9E2),
              Color(0xFF67B0DA),
              Color(0xFFCFE9E2),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: screenWidth * 0.5,
        height: 80,
        child: Center(
          child: CustomText(
            text: userType,
            size: 16,
            weight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
