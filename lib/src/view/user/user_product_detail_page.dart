import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/view/user/usercart.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class UserProduct_DetailsPage extends StatefulWidget {
  final String productId;

  UserProduct_DetailsPage({required this.productId});

  @override
  _UserProduct_DetailsPageState createState() =>
      _UserProduct_DetailsPageState();
}

class _UserProduct_DetailsPageState extends State<UserProduct_DetailsPage> {
  int quantity = 1;
  int availableQuantity = 0;

  void incrementQuantity() {
    setState(() {
      if (quantity < availableQuantity) {
        quantity++;
      } else {
        Fluttertoast.showToast(
          msg: "Cannot exceed available quantity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    if (quantity <= availableQuantity) {
      // Update stock in Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update({'quantity': availableQuantity - quantity});

      // Add to cart
      await FirebaseFirestore.instance.collection('cart').add({
        'userId': userId,
        'productId': widget.productId,
        'quantity': quantity,
      });

      // Navigate to user cart
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserCart()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE1F8F9),
        title: CustomText(
          text: 'Item Details',
          size: 20,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Color(0xffE1F8F9),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No data available'),
            );
          }

          Map<String, dynamic> productData =
              snapshot.data!.data() as Map<String, dynamic>;
          availableQuantity = productData['quantity'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.6,
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(productData['imageURL']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Name: ',
                            size: 18,
                            color: Colors.black,
                            weight: FontWeight.bold,
                          ),
                          CustomText(
                            text: productData['name'],
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.normal,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Price: ',
                            size: 18,
                            color: Colors.black,
                            weight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '\$${productData['price']}',
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.normal,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Stock: ',
                            size: 18,
                            color: Colors.black,
                            weight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '${productData['quantity']}',
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.normal,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Details: ',
                            size: 18,
                            color: Colors.black,
                            weight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '${productData['details']}',
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.normal,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText(
                            text: 'Quantity:',
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: decrementQuantity,
                                ),
                                CustomText(
                                  text: quantity.toString(),
                                  size: 16,
                                  color: Colors.black,
                                  weight: FontWeight.normal,
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: incrementQuantity,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton1(
                            text: 'Buy',
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            onPressed: addToCart,
                          ),
                          CustomButton1(
                            text: 'Cancel',
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
