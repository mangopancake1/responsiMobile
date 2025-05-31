import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../service/phone_api_service.dart';
import '../service/phone_favorite_services.dart';
import 'update_phone_page.dart';

class PhoneDetailPage extends StatefulWidget {
  static const String routeName = '/phone-detail';

  const PhoneDetailPage({Key? key}) : super(key: key);

  @override
  State<PhoneDetailPage> createState() => _PhoneDetailPageState();
}

class _PhoneDetailPageState extends State<PhoneDetailPage> {
  late int phoneId;
  late Future<Phone> _futurePhone;
  final PhoneApiService _apiService = PhoneApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is int) {
      phoneId = arguments;
      _futurePhone = _apiService.fetchPhoneById(phoneId);
    } else {
      throw Exception('PhoneDetailPage membutuhkan ID berupa integer');
    }
  }

  Future<void> _removePhone() async {
    // Implementasi untuk menghapus phone (misalnya panggil API)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail HP'),
        elevation: 0,  // Menghilangkan shadow untuk desain yang lebih clean
        backgroundColor: Colors.transparent,  // Transparan untuk kesan modern
        actions: [
          FutureBuilder<bool>(
            future: PhoneFavoriteService.isFavorite(phoneId),
            builder: (context, snapshotFav) {
              final isFavorite = snapshotFav.data ?? false;
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow[700] : Colors.white,
                ),
                onPressed: () async {
                  if (isFavorite) {
                    await PhoneFavoriteService.removeFavorite(phoneId);
                  } else {
                    final phone = await _futurePhone;
                    await PhoneFavoriteService.addFavorite(phone);
                  }
                  setState(() {});
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit HP',
            onPressed: () async {
              final didUpdate = await Navigator.pushNamed(
                context,
                UpdatePhonePage.routeName,
                arguments: phoneId,
              );
              if (didUpdate == true) {
                setState(() {
                  _futurePhone = _apiService.fetchPhoneById(phoneId);
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus HP',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Apakah Anda yakin ingin menghapus HP ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await _removePhone();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Phone>(
        future: _futurePhone,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final phone = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Hero(
                      tag: 'phone-image-${phone.id}',  // Hero animation untuk gambar
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          phone.imageUrl,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    phone.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Brand: ${phone.brand}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Harga: \$${phone.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Spesifikasi:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phone.specification,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          // Loading/Error Handling
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
