import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class CreatePage extends StatefulWidget {
  static const routeName = '/create';  // Menambahkan routeName untuk navigasi

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _specificationController = TextEditingController();

  // Fungsi untuk menambahkan data phone
  void _addPhone() {
    final name = _nameController.text;
    final brand = _brandController.text;
    final price = double.tryParse(_priceController.text);
    final specification = _specificationController.text;

    // Validasi input
    if (name.isEmpty || brand.isEmpty || price == null || specification.isEmpty) {
      return;
    }

    final phone = Phone(
      id: 0, // ID akan di-set otomatis oleh API
      name: name,
      brand: brand,
      price: price,
      imageUrl: '', // Gambar akan diatur oleh API
      specification: specification,
    );

    // Mengirim data phone baru ke API
    ApiService().addPhone(phone).then((_) {
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }).catchError((e) {
      // Menangani error jika ada masalah saat menambah phone
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add phone: $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input untuk nama phone
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Phone Name'),
            ),
            // Input untuk brand phone
            TextField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            // Input untuk harga phone
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            // Input untuk spesifikasi phone
            TextField(
              controller: _specificationController,
              decoration: InputDecoration(labelText: 'Specification'),
            ),
            SizedBox(height: 20),
            // Tombol untuk menambahkan phone
            ElevatedButton(
              onPressed: _addPhone,
              child: Text('Add Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
