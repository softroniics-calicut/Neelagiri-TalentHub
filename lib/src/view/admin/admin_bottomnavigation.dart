import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/admin/adminhome.dart';
import 'package:talenthub/src/view/admin/adminview.dart';
import 'package:talenthub/src/view/admin/adminviewwork.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({super.key});

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
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
          const Icon(Icons.home, size: 30),
          const Icon(Icons.work, size: 30),
          const Icon(Icons.view_agenda, size: 30),
        ],
        color: const Color(0xFF67B0DA),
        buttonBackgroundColor: const Color(0xFF67B0DA),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
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
        return const AdminHome();
      case 1:
        return const AdminViewWork();
      case 2:
        return const AdminView();
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }
}
