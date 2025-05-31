import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'create_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home'; // Menambahkan routeName untuk navigasi

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Phone>> phones;

  @override
  void initState() {
    super.initState();
    phones = ApiService().getPhones(); // Ambil data phone dari API
  }

  // Fungsi untuk menghapus phone
  void _deletePhone(int id) {
    ApiService().deletePhone(id).then((_) {
      setState(() {
        phones = ApiService().getPhones(); // Refresh data setelah delete
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Menggunakan Navigator.pushNamed untuk navigasi ke CreatePage
              Navigator.pushNamed(context, CreatePage.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: phones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No phones available.'));
          }

          List<Phone> phoneList = snapshot.data!;

          return ListView.builder(
            itemCount: phoneList.length,
            itemBuilder: (context, index) {
              final phone = phoneList[index];
              return ListTile(
                leading: Image.network(phone.imageUrl), // Menyesuaikan dengan imageUrl
                title: Text(phone.name),
                subtitle: Text('\$${phone.price}'), // Menyesuaikan dengan price
                onTap: () {
                  // Navigasi ke DetailPage menggunakan pushNamed dan passing parameter phoneId
                  Navigator.pushNamed(
                    context,
                    DetailPage.routeName,
                    arguments: phone.id, // Mengirim phoneId sebagai argument
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Menavigasi ke EditPage dan mengirimkan phoneId sebagai argument
                    Navigator.pushNamed(
                      context,
                      EditPage.routeName,
                      arguments: phone.id, // Mengirim phoneId sebagai argument
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
