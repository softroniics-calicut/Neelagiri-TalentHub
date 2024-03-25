import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talenthub/src/view/user/user_bottom_navigation.dart';
import 'package:talenthub/src/widget/custom_button.dart';

class UserAddProduct extends StatefulWidget {
  const UserAddProduct({Key? key}) : super(key: key);

  @override
  State<UserAddProduct> createState() => _UserAddProductState();
}

class _UserAddProductState extends State<UserAddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  File? _image;
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _image = null;
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate() && _image != null) {
      try {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(_image!);

        // Get the imageURL
        final imageURL = await ref.getDownloadURL();

        // Add product details to Firestore
        final productRef =
            await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'quantity': int.parse(_quantityController.text),
          'details': _detailsController.text,
          'imageURL': imageURL,
          'category': _selectedCategory,
        });

        // Get the ID of the newly added product document
        final productId = productRef.id;

        // Update the product document with the productId
        await productRef.update({'productId': productId});

        // Clear form fields and image
        _nameController.clear();
        _priceController.clear();
        _quantityController.clear();
        _detailsController.clear();
        setState(() {
          _image = null;
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added successfully'),
          ),
        );

        // Navigate to UserBottomNavigation screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserBottomNavigation()),
        );
      } catch (e) {
        print('Error uploading product: $e');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading product'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_image == null)
                InkWell(
                  onTap: _getImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (_image == null) // Show error if no image is selected
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Please select an image',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              // Category Dropdown
              Text(
                'Category',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: <String>['Drawing', 'Craft', 'Stitching', 'Mehandi']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD7DFDF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Name TextField
              Text(
                'Name',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD7DFDF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Price TextField
              Text(
                'Price',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD7DFDF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Quantity TextField
              Text(
                'Quantity',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD7DFDF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Details TextField
              Text(
                'Details',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _detailsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some details';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD7DFDF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: CustomButton(onPressed: _uploadProduct, text: 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
