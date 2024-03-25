import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class CollegeViewProduct extends StatefulWidget {
  const CollegeViewProduct({Key? key});

  @override
  State<CollegeViewProduct> createState() => _CollegeViewProductState();
}

class _CollegeViewProductState extends State<CollegeViewProduct> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: CustomText(
            text: 'Work',
            size: 25,
            weight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                  return buildProductCard(productData);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> productData) {
    final name = productData['name'] ?? '';
    final price = productData['price'] ?? '';
    final category = productData['category'] ?? '';
    final details = productData['details'] ?? '';
    final imageURL = productData['imageURL'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        child: Card(
          color: const Color(0xFF67B0DA),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                        image: imageURL.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imageURL),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imageURL.isEmpty
                          ? Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
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
                          const SizedBox(height: 8),
                          CustomText(
                            text: '\$$price',
                            size: 18,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: 'Category: $category',
                            size: 16,
                            color: Colors.white,
                            weight: FontWeight.normal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: 'Details: $details',
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
