import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../service/phone_api_service.dart';
import '../service/phone_favorite_services.dart';

class UpdatePhonePage extends StatefulWidget {
  static const String routeName = '/update-phone';

  const UpdatePhonePage({Key? key}) : super(key: key);

  @override
  State<UpdatePhonePage> createState() => _UpdatePhonePageState();
}

class _UpdatePhonePageState extends State<UpdatePhonePage> {
  late int phoneId;
  late Future<Phone> _futurePhone;
  final PhoneApiService _apiService = PhoneApiService();
  final _formKey = GlobalKey<FormState>();

  // Controller untuk tiap field input
  final TextEditingController _phoneNameController = TextEditingController();
  final TextEditingController _phoneBrandController = TextEditingController();
  final TextEditingController _phonePriceController = TextEditingController();
  final TextEditingController _phoneSpecificationController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is int) {
      phoneId = arguments;
      _futurePhone = _apiService.fetchPhoneById(phoneId);
      // Isi controller dengan data yang sudah di-fetch
      _futurePhone.then((phone) {
        _phoneNameController.text = phone.name;
        _phoneBrandController.text = phone.brand;
        _phonePriceController.text = phone.price.toStringAsFixed(0);
        _phoneSpecificationController.text = phone.specification;
      });
    } else {
      throw Exception('UpdatePhonePage membutuhkan argument ID berupa integer');
    }
  }

  /// Fungsi untuk submit update
  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final updatedPhone = Phone(
      id: phoneId,
      name: _phoneNameController.text.trim(),
      brand: _phoneBrandController.text.trim(),
      price: double.tryParse(_phonePriceController.text.trim()) ?? 0,
      specification: _phoneSpecificationController.text.trim(),
      imageUrl: '', // ImageUrl tetap kosong, karena server yang akan menangani
    );

    try {
      await _apiService.updatePhone(phoneId, updatedPhone);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('HP berhasil diperbarui')),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya dan beri sinyal
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error memperbarui HP: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _phoneNameController.dispose();
    _phoneBrandController.dispose();
    _phonePriceController.dispose();
    _phoneSpecificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update HP'),
      ),
      body: FutureBuilder<Phone>(
        future: _futurePhone,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Field: Name
                    TextFormField(
                      controller: _phoneNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama HP',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Nama HP wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // Field: Brand
                    TextFormField(
                      controller: _phoneBrandController,
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Brand wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // Field: Price
                    TextFormField(
                      controller: _phonePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga wajib diisi';
                        }
                        final parsed = double.tryParse(value);
                        if (parsed == null) {
                          return 'Masukkan angka yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Field: Specification
                    TextFormField(
                      controller: _phoneSpecificationController,
                      decoration: const InputDecoration(
                        labelText: 'Spesifikasi',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Spesifikasi wajib diisi' : null,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Update
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitUpdate,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Perbarui'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
