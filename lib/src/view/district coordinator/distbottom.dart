import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/district%20coordinator/dist_viewallstore.dart';
import 'package:talenthub/src/view/district%20coordinator/distprofile.dart';

class DistBottomNavigation extends StatefulWidget {
  const DistBottomNavigation({super.key});

  @override
  State<DistBottomNavigation> createState() => _DistBottomNavigationState();
}

class _DistBottomNavigationState extends State<DistBottomNavigation> {
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
        return DistViewAllCoordinator();
      case 1:
        return DistProfile();
      default:
        return Center(child: Text('Unknown Page'));
    }
  }
}
