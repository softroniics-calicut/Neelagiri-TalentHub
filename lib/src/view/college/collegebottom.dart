import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/college/CollegeViewStudentsList.dart';
import 'package:talenthub/src/view/college/college%20profile.dart';
import 'package:talenthub/src/view/college/collge%20home.dart';

class CollegeBottomNavigation extends StatefulWidget {
  const CollegeBottomNavigation({super.key});

  @override
  State<CollegeBottomNavigation> createState() =>
      _CollegeBottomNavigationState();
}

class _CollegeBottomNavigationState extends State<CollegeBottomNavigation> {
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
          Icon(Icons.view_agenda, size: 30),
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
        return CollegeViewProduct();
      case 1:
        return CollegeViewStudentsList();
      case 2:
        return CollegeProfile();
      default:
        return Center(child: Text('Unknown Page'));
    }
  }
}
