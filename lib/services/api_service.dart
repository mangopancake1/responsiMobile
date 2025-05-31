import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplication/models/phone.dart';

class ApiService {

  static const String baseUrl = 'https://resp-api-three.vercel.app/';


  Future<List<Phone>> fetchPhones() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {


      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Phone.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load phones');
    }
  }


  Future<Phone> fetchPhoneDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl$id'));
    if (response.statusCode == 200) {

      return Phone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load phone details');
    }
  }


  Future<void> createPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phone.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create phone');
    }
  }


  Future<void> editPhone(String id, Phone phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phone.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit phone');
    }
  }

  Future<void> deletePhone(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete phone');
    }
  }
}
