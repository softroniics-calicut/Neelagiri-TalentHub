import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class StoreAProveWork extends StatelessWidget {
  const StoreAProveWork({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
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
                final details = productData['details'] ?? '';
                final status = productData['status'] ?? '';

                return Container(
                  child: Card(
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
                                    Text(
                                      'Category: $category',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: status != 'Accepted'
                                    ? () {
                                        updateStatusInFirestore(
                                            'Accepted', products[index].id);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status != 'Accepted'
                                      ? Color.fromARGB(255, 37, 143, 40)
                                      : Colors.green,
                                ),
                                child: CustomText(
                                  text: 'Accept',
                                  color: Colors.white,
                                  size: 15,
                                  weight: FontWeight.normal,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: status != 'Accepted'
                                    ? () {
                                        updateStatusInFirestore(
                                            'Rejected', products[index].id);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status != 'Accepted'
                                      ? Colors.red
                                      : Colors.red,
                                ),
                                child: CustomText(
                                  text: 'Reject',
                                  color: Colors.white,
                                  size: 12,
                                  weight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Status: $status',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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

  void updateStatusInFirestore(String status, String productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'status': status}).then((value) {
      print('Status updated successfully to $status');
    }).catchError((error) {
      print('Failed to update status: $error');
    });
  }
}
