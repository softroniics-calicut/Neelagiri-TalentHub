import 'package:flutter/material.dart';
import 'package:talenthub/src/models/landing%20page.dart';
import 'package:talenthub/src/view/admin/admincoordinatorview.dart';
import 'package:talenthub/src/view/admin/adminviewstorekeeper.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView>
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
          text: 'View Others',
          size: 25,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
            icon: Icon(Icons.logout_sharp),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xFF67B0DA),
              borderRadius: BorderRadius.circular(18), // Circular radius
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                    child: CustomText(
                  text: 'StoreKeeper',
                  size: 15,
                  color: Colors.black,
                  weight: FontWeight.bold,
                )),
                Tab(
                    child: CustomText(
                  text: 'Coordinator',
                  size: 15,
                  color: Colors.black,
                  weight: FontWeight.bold,
                )),
              ],
              indicatorColor: Color(0xFFD2F5F5), // Selected tab color
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StorekeeperView(),
          AdminCoordinatorView(),
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
