import 'package:flutter/material.dart';
import 'package:talenthub/src/view/store_keeper/reject_work.dart';
import 'package:talenthub/src/view/store_keeper/store_viewproduct.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class StoreHome extends StatefulWidget {
  const StoreHome({Key? key}) : super(key: key);

  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome>
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
          text: 'Talent-hub',
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
                  Icon(Icons.work),
                  SizedBox(width: 5),
                  CustomText(
                    text: 'View works',
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
                  Icon(Icons.work_off_outlined),
                  SizedBox(width: 5),
                  CustomText(
                    text: 'Accept/Reject',
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
            child: StoreViewProduct(),
          ),
          Center(
            child: StoreAProveWork(),
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
