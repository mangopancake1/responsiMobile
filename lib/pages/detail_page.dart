import 'package:flutter/material.dart';
import 'package:aplication/services/api_service.dart';
import 'package:aplication/models/phone.dart';
import 'package:aplication/pages/edit_page.dart';

class DetailPage extends StatefulWidget {
  final String phoneId;

  DetailPage({required this.phoneId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService apiService = ApiService();
  late Future<Phone> phone;

  @override
  void initState() {
    super.initState();

    phone = apiService.fetchPhoneDetails(widget.phoneId);
  }


  void _deletePhone(String id) {
    apiService.deletePhone(id).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Phone deleted successfully!'),
      ));
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah penghapusan
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete phone: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Details'),
      ),
      body: FutureBuilder<Phone>(
        future: phone,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No phone data found'));
          }

          final phone = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network(phone.imageUrl), // Gambar ponsel
                SizedBox(height: 16),
                Text(
                  'Name: ${phone.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Brand: ${phone.brand}', style: TextStyle(fontSize: 18)),
                Text('Price: ${phone.price}', style: TextStyle(fontSize: 18)),
                Text('Specification: ${phone.specification}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(phoneId: phone.id),
                          ),
                        );
                      },
                      child: Text('Edit'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _deletePhone(phone.id);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
