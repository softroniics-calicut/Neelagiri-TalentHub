import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talenthub/src/view/user/userpurchases.dart';
import 'package:talenthub/src/widget/custom_button.dart';
import 'package:talenthub/src/widget/custom_text.dart';

class CartItem {
  String name;
  double price;
  String image;
  String productId;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.productId,
    required this.quantity,
  });
}

class UserCart extends StatefulWidget {
  const UserCart({Key? key}) : super(key: key);

  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        String productId = doc['productId'];
        int quantity = doc['quantity'];
        await fetchProductDetails(productId, quantity);
      });
    });
  }

  Future<void> fetchProductDetails(String productId, int quantity) async {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String name = documentSnapshot['name'];
        double price = documentSnapshot['price'];
        String image = documentSnapshot['imageURL'];

        setState(() {
          cartItems.add(CartItem(
            name: name,
            price: price,
            image: image,
            productId: productId,
            quantity: quantity,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: CustomText(
            text: 'Cart',
            weight: FontWeight.normal,
            color: Colors.black,
            size: 20,
          ),
        ),
        backgroundColor: const Color(0xFF67B0DA),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        child: cartItems.isEmpty
            ? Center(
                child: Lottie.asset(
                  'assets/empty_cart_animation.json',
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        tileColor: Color.fromARGB(255, 180, 221, 244),
                        leading: Image.network(cartItems[index].image),
                        title: CustomText(
                          text: cartItems[index].name,
                          weight: FontWeight.normal,
                          color: Colors.black,
                          size: 16,
                        ),
                        subtitle: CustomText(
                          text:
                              'Price: \$${cartItems[index].price.toStringAsFixed(2)} | Quantity: ${cartItems[index].quantity}',
                          weight: FontWeight.normal,
                          color: Colors.black,
                          size: 14,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            removeFromCart(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPurchaseSuccessful(),
                  ),
                );
              },
              text: 'Checkout',
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void removeFromCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    String productId = cartItems[index].productId;
    int quantity = cartItems[index].quantity;

    // Remove from cart collection
    await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    // Add quantity back to product collection
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'quantity': FieldValue.increment(quantity)});

    setState(() {
      cartItems.removeAt(index);
    });
  }
}
