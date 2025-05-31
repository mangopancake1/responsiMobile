import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../service/phone_api_service.dart';

class AddPhonePage extends StatefulWidget {
  static const String routeName = '/add-phone';

  const AddPhonePage({Key? key}) : super(key: key);

  @override
  State<AddPhonePage> createState() => _AddPhonePageState();
}

class _AddPhonePageState extends State<AddPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final PhoneApiService _apiService = PhoneApiService();

  // Controller untuk setiap field input
  final TextEditingController _phoneNameController = TextEditingController();
  final TextEditingController _phoneBrandController = TextEditingController();
  final TextEditingController _phonePriceController = TextEditingController();
  final TextEditingController _phoneSpecificationController = TextEditingController();

  bool _isSubmitting = false;

  /// Fungsi untuk menambahkan phone baru
  Future<void> _addPhone() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final phone = Phone(
      id: 0, // ID akan dibuat oleh server
      name: _phoneNameController.text.trim(),
      brand: _phoneBrandController.text.trim(),
      price: double.tryParse(_phonePriceController.text.trim()) ?? 0,
      specification: _phoneSpecificationController.text.trim(),
      imageUrl: '', // Tidak diperlukan, karena server akan menanganinya
    );

    try {
      await _apiService.createPhone(phone);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // Mengirim sinyal ke halaman utama bahwa ada item baru
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
        title: const Text('Tambah HP Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input: Name
              TextFormField(
                controller: _phoneNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama HP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Input: Brand
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

              // Input: Price
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
                    return 'Masukkan harga yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input: Specification
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

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _addPhone,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
