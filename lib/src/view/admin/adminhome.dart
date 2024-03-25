import 'package:flutter/material.dart';
import 'package:talenthub/src/view/admin/admincollege.dart';
import 'package:talenthub/src/view/admin/adminstudet.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Admin Home',
          size: 25,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school),
                  SizedBox(width: 5),
                  CustomText(
                    text: 'College',
                    size: 16,
                    weight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 5),
                  CustomText(
                    text: 'Student',
                    size: 16,
                    weight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: AdminviewCollege(),
          ),
          Center(
            child: AdminViewStudent(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
