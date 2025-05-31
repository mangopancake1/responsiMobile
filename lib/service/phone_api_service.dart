import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';

class PhoneApiService {
  static const String baseUrl = 'https://resp-api-three.vercel.app';

  Future<List<Phone>> fetchAllPhones() async {
    final response = await http.get(Uri.parse('$baseUrl/phones'));


    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
        final List<dynamic> dataList = jsonMap['data'];
        return dataList
            .map((jsonItem) => Phone.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Data field is missing or not a list');
      }
    } else {
      throw Exception('Failed to load phones (status ${response.statusCode})');
    }
  }

  Future<Phone> fetchPhoneById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/phone/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          json.decode(response.body) as Map<String, dynamic>;

      if (jsonMap.containsKey('data')) {
        return Phone.fromJson(jsonMap['data']);
      } else {
        throw Exception('Data not found in response');
      }
    } else {
      throw Exception('Failed to load phone with id $id');
    }
  }

  Future<Phone> createPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phone'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(phone.toJson()),
    );


    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> createdJson =
          json.decode(response.body) as Map<String, dynamic>;
      return Phone.fromJson(createdJson);
    } else {
      throw Exception('Failed to create phone (status ${response.statusCode})');
    }
  }

  Future<Phone> updatePhone(int id, Phone phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phone/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(phone.toJson()),
    );


    if (response.statusCode == 200) {
      final Map<String, dynamic> updatedJson =
          json.decode(response.body) as Map<String, dynamic>;
      return Phone.fromJson(updatedJson);
    } else {
      throw Exception('Failed to update phone with id $id');
    }
  }

  Future<void> deletePhone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/phone/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete phone with id $id');
    }
  }
}
