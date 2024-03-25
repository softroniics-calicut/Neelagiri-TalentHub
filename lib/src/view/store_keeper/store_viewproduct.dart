import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class ProductItem extends StatelessWidget {
  final String imageURL;
  final String name;
  final double price;
  final String details;
  final String category;
  final String status;

  const ProductItem({
    required this.imageURL,
    required this.name,
    required this.price,
    required this.details,
    required this.category,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF67B0DA),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
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
              weight: FontWeight.normal,
            ),
            SizedBox(height: 8),
            CustomText(
              text: 'Details: $details',
              size: 16,
              color: Colors.white,
              weight: FontWeight.normal,
            ),
            SizedBox(height: 8),
            CustomText(
              text: 'Status: ${status ?? 'Pending'}',
              size: 16,
              color: Colors.black,
              weight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}

class StoreViewProduct extends StatefulWidget {
  const StoreViewProduct({Key? key}) : super(key: key);

  @override
  State<StoreViewProduct> createState() => _StoreViewProductState();
}

class _StoreViewProductState extends State<StoreViewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final productData =
                    products[index].data() as Map<String, dynamic>;
                return ProductItem(
                  imageURL: productData['imageURL'],
                  name: productData['name'],
                  price: productData['price'],
                  details: productData['details'],
                  category: productData['category'],
                  status: productData['status'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
