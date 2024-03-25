import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/view/user/user_product_detail_page.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class UserProductLists extends StatefulWidget {
  final String category;

  const UserProductLists({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _UserProductListsState createState() => _UserProductListsState();
}

class _UserProductListsState extends State<UserProductLists> {
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1F8F9),
        title: CustomText(
          text: 'All Products',
          size: 20,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Color(0xffE1F8F9),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF67B0DA),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('category', isEqualTo: widget.category)
                    .where('status', isEqualTo: 'Accepted')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(), // Show loading indicator
                    );
                  }

                  List<DocumentSnapshot> products = snapshot.data!.docs;

                  // Filter products based on name
                  if (searchQuery != null && searchQuery!.isNotEmpty) {
                    products = products
                        .where((product) => product['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery!.toLowerCase()))
                        .toList();
                  }

                  List<Widget> productWidgets = [];

                  for (int i = 0; i < products.length; i += 2) {
                    if (i + 1 < products.length) {
                      productWidgets.add(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProductItem(
                            imageUrl: products[i]['imageURL'],
                            name: products[i]['name'],
                            productId: products[i].id,
                            screenSize: screenSize,
                          ),
                          ProductItem(
                            imageUrl: products[i + 1]['imageURL'],
                            name: products[i + 1]['name'],
                            productId: products[i + 1].id,
                            screenSize: screenSize,
                          ),
                        ],
                      ));
                    } else {
                      // Handle the case when there's only one item left
                      productWidgets.add(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProductItem(
                            imageUrl: products[i]['imageURL'],
                            name: products[i]['name'],
                            productId: products[i].id,
                            screenSize: screenSize,
                          ),
                        ],
                      ));
                    }
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: productWidgets,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String productId;
  final Size screenSize;

  const ProductItem({
    required this.imageUrl,
    required this.name,
    required this.productId,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenSize.width * 0.4,
        height: screenSize.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.width * 0.25,
              height: screenSize.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            CustomText(
              text: name,
              size: 16,
              weight: FontWeight.bold,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProduct_DetailsPage(
                      productId: productId,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF59C7DF)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: CustomText(
                text: 'Open',
                size: 14,
                weight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
