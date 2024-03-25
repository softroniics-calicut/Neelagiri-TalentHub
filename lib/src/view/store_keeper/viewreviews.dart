import 'package:flutter/material.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: CustomText(
            text: 'Reviews',
            color: Colors.black,
            size: 25,
            weight: FontWeight.normal,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(reviews[index].productImage),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: reviews[index].productName,
                  size: 18,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    SizedBox(width: 5),
                    Text('${reviews[index].rating}'),
                    SizedBox(width: 10),
                    Text('by ${reviews[index].username}'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Review {
  final String productImage;
  final String productName;
  final double rating;
  final String username;

  Review({
    required this.productImage,
    required this.productName,
    required this.rating,
    required this.username,
  });
}

List<Review> reviews = [
  Review(
    productImage: 'assets/mehandi.png',
    productName: 'Product 1',
    rating: 4.5,
    username: 'user1',
  ),
  Review(
    productImage: 'assets/mehandi.png',
    productName: 'Product 2',
    rating: 3.8,
    username: 'user2',
  ),
  Review(
    productImage: 'assets/mehandi.png',
    productName: 'Product 3',
    rating: 5.0,
    username: 'user3',
  ),
];
