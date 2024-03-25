import 'package:flutter/material.dart';
import 'package:talenthub/src/view/college/acceptstudent.dart';
import 'package:talenthub/src/view/college/college%20view%20student.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class CollegeViewStudentsList extends StatefulWidget {
  const CollegeViewStudentsList({Key? key}) : super(key: key);

  @override
  State<CollegeViewStudentsList> createState() =>
      _CollegeViewStudentsListState();
}

class _CollegeViewStudentsListState extends State<CollegeViewStudentsList>
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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  CustomText(
                    text: 'Students view',
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
                  SizedBox(width: 5),
                  CustomText(
                    text: 'Accept / Reject',
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
            child: CollegViewStudent(),
          ),
          Center(
            child: CollegAcceptStudent(),
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
