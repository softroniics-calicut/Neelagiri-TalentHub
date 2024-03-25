import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class StoreDisableWork extends StatefulWidget {
  const StoreDisableWork({Key? key});

  @override
  State<StoreDisableWork> createState() => _StoreDisableWorkState();
}

class _StoreDisableWorkState extends State<StoreDisableWork> {
  bool workDisabled = false;

  void disableWork() {
    setState(() {
      workDisabled = true;
    });
  }

  void updateStatusInFirestore(String productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'status': 'Disabled'}).then((value) {
      print('Work Disabled for product: $productId');
    }).catchError((error) {
      print('Failed to update status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: CustomText(
            text: 'Disable work',
            size: 25,
            weight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 10.0, right: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final products = snapshot.data!.docs;
            if (products.isEmpty) {
              return Center(child: Text('No products found'));
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final productData =
                    products[index].data() as Map<String, dynamic>;
                final imageURL = productData['imageURL'] ?? '';
                final name = productData['name'] ?? '';
                final price = (productData['price'] ?? 0).toDouble();
                final category = productData['category'] ?? '';
                final status = productData['status'] ?? '';

                final details = productData['details'] ?? '';

                return Card(
                  color: Color(0xFF67B0DA),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(imageURL),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: name,
                                    size: 20,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    text: '\$$price',
                                    size: 18,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    text: 'Category: $category',
                                    size: 16,
                                    color: Colors.white,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        CustomText(
                          text: 'Details: $details',
                          size: 16,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                        SizedBox(height: 16),
                        if (!workDisabled)
                          ElevatedButton(
                            onPressed: () {
                              disableWork();
                              updateStatusInFirestore(products[index].id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: CustomText(
                              text: 'Disable Work',
                              color: Colors.black,
                              weight: FontWeight.bold,
                              size: 15,
                            ),
                          ),
                        if (workDisabled)
                          CustomText(
                            text: 'Work Disabled',
                            size: 16,
                            color: Colors.red,
                            weight: FontWeight.bold,
                          ),
                        SizedBox(height: 8),
                        CustomText(
                          text: 'Satus: $status',
                          size: 16,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
