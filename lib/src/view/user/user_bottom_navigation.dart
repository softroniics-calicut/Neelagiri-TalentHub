import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/user/user_addproduct.dart';
import 'package:talenthub/src/view/user/user_home.dart';
import 'package:talenthub/src/view/user/user_profile.dart';

class UserBottomNavigation extends StatefulWidget {
  const UserBottomNavigation({super.key});

  @override
  State<UserBottomNavigation> createState() => _UserBottomNavigationState();
}

class _UserBottomNavigationState extends State<UserBottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add_box, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Color(0xFF67B0DA),
        buttonBackgroundColor: Color(0xFF67B0DA),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return UserHome();
      case 1:
        return UserAddProduct();
      case 2:
        return UserProfile();
      default:
        return Center(child: Text('Unknown Page'));
    }
  }
}
