import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';
import '../constants/api_constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl; // Menggunakan baseUrl dari ApiConstants

  // Mengambil seluruh data phone
  Future<List<Phone>> getPhones() async {
    final String proxyUrl = 'https://cors-anywhere.herokuapp.com/'; // Proxy URL
    final String targetUrl = '$baseUrl/phones'; // Target API URL

    final response = await http.get(
      Uri.parse('$proxyUrl$targetUrl'),
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY', // Ganti dengan kunci API Anda
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((phoneData) => Phone.fromJson(phoneData)).toList();
    } else {
      throw Exception('Failed to load phones');
    }
  }

  // Menambahkan data phone baru
  Future<void> addPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phones'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phone.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add phone');
    }
  }

  // Mengedit data phone
  Future<void> updatePhone(int id, Phone phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phones/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phone.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update phone');
    }
  }

  // Menghapus data phone
  Future<void> deletePhone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/phones/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete phone');
    }
  }
}
