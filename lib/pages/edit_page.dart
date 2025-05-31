// /lib/pages/edit_page.dart

import 'package:flutter/material.dart';
import 'package:aplication/services/api_service.dart';
import 'package:aplication/models/phone.dart';

class EditPage extends StatefulWidget {
  final String phoneId;

  EditPage({required this.phoneId});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final ApiService apiService = ApiService();

  // Controllers untuk input form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specificationController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  late Future<Phone> phone;

  @override
  void initState() {
    super.initState();
    // Mengambil data detail ponsel untuk diedit
    phone = apiService.fetchPhoneDetails(widget.phoneId);
  }

  // Fungsi untuk menyimpan perubahan ponsel
  void _savePhone() {
    final updatedPhone = Phone(
      id: widget.phoneId, // ID ponsel tetap tidak berubah
      name: nameController.text,
      brand: brandController.text,
      price: priceController.text,
      imageUrl: imageUrlController.text,
      specification: specificationController.text,
    );

    apiService.editPhone(widget.phoneId, updatedPhone).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Phone updated successfully!'),
      ));
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah update
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update phone: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Phone'),
      ),
      body: FutureBuilder<Phone>(
        future: phone,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No phone data found'));
          }

          final phone = snapshot.data!;

          // Inisialisasi controller dengan data yang ada
          nameController.text = phone.name;
          brandController.text = phone.brand;
          priceController.text = phone.price;
          specificationController.text = phone.specification;
          imageUrlController.text = phone.imageUrl;

          return Padding(
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
                  onPressed: _savePhone,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
