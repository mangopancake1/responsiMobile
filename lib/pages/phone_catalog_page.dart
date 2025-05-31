import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../service/phone_api_service.dart';
import '../service/phone_favorite_services.dart';
import 'favorite_phones_page.dart';
import 'phone_detail_page.dart';
import 'update_phone_page.dart';
import 'add_phone_page.dart';

class PhoneCatalogPage extends StatefulWidget {
  static const String routeName = '/phone-catalog';

  const PhoneCatalogPage({Key? key}) : super(key: key);

  @override
  State<PhoneCatalogPage> createState() => _PhoneCatalogPageState();
}

class _PhoneCatalogPageState extends State<PhoneCatalogPage> {
  late Future<List<Phone>> _futurePhones;
  final PhoneApiService _apiService = PhoneApiService();
  Set<int> _favoritePhoneIds = {};

  @override
  void initState() {
    super.initState();
    _loadPhoneData();
  }

  void _loadPhoneData() {
    _futurePhones = _apiService.fetchAllPhones();
    _loadFavoritePhones();
  }

  void _loadFavoritePhones() async {
    final favorites = await PhoneFavoriteService.getFavorites();
    setState(() {
      _favoritePhoneIds = favorites.map((phone) => phone.id).toSet();
    });
  }

  void _toggleFavorite(Phone phone) async {
    if (_favoritePhoneIds.contains(phone.id)) {
      await PhoneFavoriteService.removeFavorite(phone.id);
    } else {
      await PhoneFavoriteService.addFavorite(phone);
    }
    _loadFavoritePhones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog HP',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0, // No shadow for clean UI
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.yellow),
            tooltip: 'HP Favorit Saya',
            onPressed: () {
              Navigator.pushNamed(
                context,
                FavoritePhonesPage.routeName,
              ).then((_) => _loadFavoritePhones());
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Tambah HP',
            onPressed: () async {
              final didCreate = await Navigator.pushNamed(
                context,
                AddPhonePage.routeName,
              );
              if (didCreate == true) {
                setState(() {
                  _loadPhoneData();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: _futurePhones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data HP.'));
          } else {
            final phones = snapshot.data!;
            return ListView.builder(
              itemCount: phones.length,
              itemBuilder: (context, index) {
                final phone = phones[index];
                final isFav = _favoritePhoneIds.contains(phone.id);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PhoneDetailPage.routeName,
                        arguments: phone.id,
                      ).then((_) => _loadFavoritePhones());
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              phone.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 80),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  phone.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Harga: \$${phone.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.star : Icons.star_border,
                                  color: isFav ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () {
                                  _toggleFavorite(phone);
                                },
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    final didUpdate = await Navigator.pushNamed(
                                      context,
                                      UpdatePhonePage.routeName,
                                      arguments: phone.id,
                                    );
                                    if (didUpdate == true) {
                                      setState(() {
                                        _loadPhoneData();
                                      });
                                    }
                                  } else if (value == 'delete') {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                              'Hapus HP ini?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      ctx,
                                                      false,
                                                    ),
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      ctx,
                                                      true,
                                                    ),
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirmed == true) {
                                      await _apiService.deletePhone(phone.id);
                                      setState(() {
                                        _loadPhoneData();
                                      });
                                    }
                                  }
                                },
                                itemBuilder:
                                    (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
