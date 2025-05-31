import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../service/phone_favorite_services.dart';
import '../service/phone_api_service.dart';
import 'phone_detail_page.dart';

class FavoritePhonesPage extends StatefulWidget {
  static const String routeName = '/favorite-phones';

  const FavoritePhonesPage({Key? key}) : super(key: key);

  @override
  State<FavoritePhonesPage> createState() => _FavoritePhonesPageState();
}

class _FavoritePhonesPageState extends State<FavoritePhonesPage> {
  late Future<List<Phone>> _futureFavoritePhones;
  final PhoneFavoriteService _phoneFavoriteService = PhoneFavoriteService();
  final PhoneApiService _apiService = PhoneApiService();

  @override
  void initState() {
    super.initState();
    _loadFavoritePhones();  // Memanggil _loadFavoritePhones untuk memuat data favorit
  }

  // Fungsi untuk memuat data favorit
  Future<List<Phone>> _loadFavoritePhones() async {
    final allPhones = await _apiService.fetchAllPhones();  // Mengambil semua HP
    final favPhones = await PhoneFavoriteService.getFavorites();  // Mengambil HP favorit
    final favIds = favPhones.map((p) => p.id).toSet();  // ID favorit yang sudah dipilih
    return allPhones.where((phone) => favIds.contains(phone.id)).toList();  // Filter HP favorit
  }

  void _loadFavorites() {
    _futureFavoritePhones = _loadFavoritePhones();  // Memuat ulang data favorit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HP Favorit Saya'),
      ),
      body: FutureBuilder<List<Phone>>(
        future: _futureFavoritePhones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Menunggu data
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada HP favorit.'));  // Tidak ada data favorit
          } else {
            final phones = snapshot.data!;  // Data HP favorit
            return ListView.builder(
              itemCount: phones.length,
              itemBuilder: (context, index) {
                final phone = phones[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.network(
                        phone.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    title: Text(phone.name),
                    subtitle: Text('Harga: \$${phone.price.toStringAsFixed(0)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await PhoneFavoriteService.removeFavorite(phone.id);  // Menghapus dari favorit
                        _loadFavorites();  // Refresh data favorit
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PhoneDetailPage.routeName,
                        arguments: phone.id,  // Menampilkan detail HP
                      ).then((_) {
                        // Menyegarkan daftar favorit setelah toggle favorit di DetailPage
                        _loadFavorites();
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
