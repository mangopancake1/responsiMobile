import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  // Menyimpan ID phone favorit
  Future<void> addFavorite(int phoneId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(phoneId.toString());  // Ubah phoneId ke string saat menyimpan
    await prefs.setStringList('favorites', favorites);
  }

  // Menghapus phone dari daftar favorit
  Future<void> removeFavorite(int phoneId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(phoneId.toString());  // Ubah phoneId ke string saat menghapus
    await prefs.setStringList('favorites', favorites);
  }

  // Mendapatkan daftar phone favorit
  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites.map((e) => int.parse(e)).toList();  // Mengubah string ke int
  }

  // Mengecek apakah phone ada di favorit
  Future<bool> isFavorite(int phoneId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites.contains(phoneId.toString());  // Ubah phoneId ke string saat memeriksa
  }
}
