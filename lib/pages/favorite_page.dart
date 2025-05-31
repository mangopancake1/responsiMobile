import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import '../services/favorite_services.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  static const routeName = '/favorites';  // Menambahkan routeName untuk navigasi

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<int>> favoriteIds; // Gunakan int untuk ID

  @override
  void initState() {
    super.initState();
    favoriteIds = FavoriteService().getFavorites(); // Ambil daftar phone favorit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: FutureBuilder<List<int>>(
        future: favoriteIds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          }

          List<int> favoriteList = snapshot.data!;

          return FutureBuilder<List<Phone>>(
            future: ApiService().getPhones(),
            builder: (context, phoneSnapshot) {
              if (phoneSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (phoneSnapshot.hasError) {
                return Center(child: Text('Error: ${phoneSnapshot.error}'));
              } else if (!phoneSnapshot.hasData) {
                return Center(child: Text('No phone data available.'));
              }

              List<Phone> phones = phoneSnapshot.data!;
              List<Phone> favoritePhones = phones.where((phone) {
                return favoriteList.contains(phone.id); // Periksa ID favorit
              }).toList();

              return ListView.builder(
                itemCount: favoritePhones.length,
                itemBuilder: (context, index) {
                  final phone = favoritePhones[index];
                  return ListTile(
                    leading: Image.network(phone.imageUrl), // Gunakan imageUrl
                    title: Text(phone.name),
                    subtitle: Text('\$${phone.price}'),
                    onTap: () {
                      // Navigasi ke DetailPage dengan passing phoneId
                      Navigator.pushNamed(
                        context,
                        DetailPage.routeName,
                        arguments: phone.id,  // Mengirim phoneId sebagai argument
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
