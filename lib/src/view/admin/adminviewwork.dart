import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class AdminViewWork extends StatelessWidget {
  const AdminViewWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF67B0DA),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'View works',
          size: 25,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackView(
                    image: '',
                    productName: '',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.feedback),
            tooltip: 'View Feedback',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!.docs;
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final productData =
                  products[index].data() as Map<String, dynamic>;
              final productName = productData['name'] ?? '';
              final price = (productData['price'] ?? 0).toDouble();
              final category = productData['category'] ?? '';
              final imageURL = productData['imageURL'] ?? '';
              final status = productData['status'] ?? 'Pending';

              return ProductCard(
                productName: productName,
                price: price,
                category: category,
                imageURL: imageURL,
                status: status,
              );
            },
          );
        },
      ),
    );
  }
}

class FeedbackView extends StatelessWidget {
  final String image;
  final String productName;

  const FeedbackView({
    Key? key,
    required this.image,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Feedback',
          size: 25,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Feedback cards here
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final String category;
  final String imageURL;
  final String status;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.price,
    required this.category,
    required this.imageURL,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusTextColor = status == 'Accepted' ? Colors.red : Colors.black;

    return Card(
      color: const Color(0xFF67B0DA),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: productName,
                    size: 18,
                    weight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text:
                        'Price: \$${price.toStringAsFixed(2)}', // Convert double to string
                    size: 16,
                    color: Colors.black,
                    weight: FontWeight.normal,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: 'Category: $category',
                    size: 16,
                    color: Colors.black,
                    weight: FontWeight.normal,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CustomText(
                      text: 'Status: $status',
                      size: 14,
                      color: statusTextColor,
                      weight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
