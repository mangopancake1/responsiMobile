import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phone.dart';

class PhoneFavoriteService {
  static const String _prefsKey = 'favorite_phones';

  /// Mengambil semua Phone yang difavorite dari SharedPreferences
  static Future<List<Phone>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favList = prefs.getStringList(_prefsKey);
    if (favList == null) return [];

    // Decode tiap JSON-string menjadi Map lalu jadi Phone
    return favList
        .map((jsonStr) =>
            Phone.fromJson(json.decode(jsonStr) as Map<String, dynamic>))
        .toList();
  }

  /// Cek apakah Phone dengan id tertentu sudah difavorite
  static Future<bool> isFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favList = prefs.getStringList(_prefsKey);
    if (favList == null) return false;

    for (var jsonStr in favList) {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      if ((map['id'] as int) == id) {
        return true;
      }
    }
    return false;
  }

  /// Menambahkan Phone ke favorite
  static Future<void> addFavorite(Phone phone) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favList = prefs.getStringList(_prefsKey) ?? [];

    // Jika belum ada di favorit, tambahkan
    final bool alreadyExists = favList.any((jsonStr) {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return (map['id'] as int) == phone.id;
    });

    if (!alreadyExists) {
      favList.add(json.encode(phone.toJsonWithId()));
      await prefs.setStringList(_prefsKey, favList);
    }
  }

  /// Menghapus Phone dari favorite berdasarkan ID
  static Future<void> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favList = prefs.getStringList(_prefsKey);
    if (favList == null) return;

    favList.removeWhere((jsonStr) {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return (map['id'] as int) == id;
    });

    await prefs.setStringList(_prefsKey, favList);
  }
}
