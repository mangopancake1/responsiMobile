import 'package:flutter/material.dart';
import 'package:aplication/services/api_service.dart';
import 'package:aplication/models/phone.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final ApiService apiService = ApiService();


  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specificationController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();


  void _createPhone() {
    if (nameController.text.isNotEmpty &&
        brandController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        specificationController.text.isNotEmpty &&
        imageUrlController.text.isNotEmpty) {
      final newPhone = Phone(
        id: '', 
        name: nameController.text,
        brand: brandController.text,
        price: priceController.text,
        imageUrl: imageUrlController.text,
        specification: specificationController.text,
      );

  
      apiService.createPhone(newPhone).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone created successfully!')),
        );

        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create phone: $error')),
        );
      });
    } else {
      // Jika ada field kosong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Phone Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: specificationController,
              decoration: InputDecoration(
                labelText: 'Specification',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPhone,
              child: Text('Create Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
