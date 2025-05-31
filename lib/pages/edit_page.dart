import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  static const routeName = '/edit';  // Menambahkan routeName untuk navigasi

  final int phoneId;  // phoneId untuk mengidentifikasi phone yang akan diedit

  const EditPage({Key? key, required this.phoneId}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late Phone _phone;
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _specificationController = TextEditingController();

  // Ambil data phone untuk diedit
  @override
  void initState() {
    super.initState();

    // Mengambil phoneId dari arguments
    final phoneId = ModalRoute.of(context)!.settings.arguments as int;

    ApiService().getPhones().then((phones) {
      _phone = phones.firstWhere((p) => p.id == phoneId);
      _nameController.text = _phone.name;
      _brandController.text = _phone.brand;
      _priceController.text = _phone.price.toString();
      _specificationController.text = _phone.specification;
    });
  }

  // Fungsi untuk memperbarui data phone
  void _updatePhone() {
    final name = _nameController.text;
    final brand = _brandController.text;
    final price = double.tryParse(_priceController.text);
    final specification = _specificationController.text;

    if (name.isEmpty || brand.isEmpty || price == null || specification.isEmpty) {
      return;
    }

    final updatedPhone = Phone(
      id: _phone.id,
      name: name,
      brand: brand,
      price: price,
      imageUrl: _phone.imageUrl,  // Gambar tetap sama
      specification: specification,
    );

    ApiService().updatePhone(_phone.id, updatedPhone).then((_) {
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Phone Name'),
            ),
            TextField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _specificationController,
              decoration: InputDecoration(labelText: 'Specification'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePhone,
              child: Text('Update Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
