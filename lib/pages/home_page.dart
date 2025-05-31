// /lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:aplication/services/api_service.dart';
import 'package:aplication/models/phone.dart';
import 'package:aplication/pages/detail_page.dart';
import 'package:aplication/pages/edit_page.dart';
import 'package:aplication/pages/create_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  late Future<List<Phone>> phones;

  @override
  void initState() {
    super.initState();
    // Mengambil data ponsel dari API 
    phones = apiService.fetchPhones();
  }

  // Fungsi untuk menghapus ponsel dari daftar
  void _deletePhone(String id) {
    apiService.deletePhone(id).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Phone deleted successfully!'),
      ));
      
      setState(() {
        phones = apiService.fetchPhones();
      });
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
        title: Text('Phone List'),
      ),
      body: FutureBuilder<List<Phone>>(
        future: phones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No phones found'));
          }

          final phoneList = snapshot.data!;
          return ListView.builder(
            itemCount: phoneList.length,
            itemBuilder: (context, index) {
              final phone = phoneList[index];
              return ListTile(
                title: Text(phone.name),
                subtitle: Text('Price: ${phone.price}'),
                leading: Image.network(phone.imageUrl),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Edit untuk mengarahkan ke halaman Edit
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(phoneId: phone.id),
                          ),
                        );
                      },
                    ),
                    // Tombol Delete untuk menghapus ponsel
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletePhone(phone.id);
                      },
                    ),
                  ],
                ),
                // Ketika ponsel diklik, arahkan ke halaman Detail
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(phoneId: phone.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Tombol untuk membuat ponsel baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
