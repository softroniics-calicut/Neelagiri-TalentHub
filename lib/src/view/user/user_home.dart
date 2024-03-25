import 'package:flutter/material.dart';
import 'package:talenthub/src/view/user/user_prodcut_list.dart';
import 'package:talenthub/src/view/user/usercart.dart';
import 'package:talenthub/src/view/user/userviewnotification.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF67B0DA),
        automaticallyImplyLeading: false,
        title: const CustomText(
          text: 'Talent hub',
          size: 20,
          weight: FontWeight.bold,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserViewnotification(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_active),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserCart(),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
      backgroundColor: Color(0xffE1F8F9),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 8),
            CustomText(
              text: "Works",
              size: 30,
              weight: FontWeight.bold,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _navigateToProductList(context, 'Drawing');
                        },
                        child: _buildCategoryContainer(
                          image: 'assets/drawing.jpg',
                          productType: 'Drawing',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _navigateToProductList(context, 'Craft');
                        },
                        child: _buildCategoryContainer(
                          image: 'assets/craft.jpg',
                          productType: 'Craft',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _navigateToProductList(context, 'Stitching');
                        },
                        child: _buildCategoryContainer(
                          image: 'assets/stiching.jpg',
                          productType: 'Stitching',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _navigateToProductList(context, 'Mehandi');
                        },
                        child: _buildCategoryContainer(
                          image: 'assets/mehandi.jpg',
                          productType: 'Mehandi',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductList(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProductLists(category: category),
      ),
    );
  }

  Widget _buildCategoryContainer(
      {required String image, required String productType}) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          CustomText(
            weight: FontWeight.bold,
            text: productType,
            size: 16,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
