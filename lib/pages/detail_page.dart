import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import 'edit_page.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';  // Menambahkan routeName untuk navigasi

  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Phone> phone;

  @override
  void initState() {
    super.initState();

    // Mengambil phoneId dari arguments yang diteruskan melalui Navigator.pushNamed
    final phoneId = ModalRoute.of(context)!.settings.arguments as int;

    // Mengambil data phone berdasarkan ID
    phone = ApiService().getPhones().then((phones) {
      return phones.firstWhere((p) => p.id == phoneId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Details')),
      body: FutureBuilder<Phone>(
        future: phone,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          }

          final phone = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network(phone.imageUrl), // Menampilkan gambar
                SizedBox(height: 16),
                Text(phone.name, style: TextStyle(fontSize: 24)),
                Text(phone.specification, style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('\$${phone.price}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Edit
                    ElevatedButton(
                      onPressed: () {
                        // Navigasi ke EditPage menggunakan pushNamed dan mengirimkan phoneId
                        Navigator.pushNamed(
                          context,
                          EditPage.routeName,
                          arguments: phone.id,  // Mengirimkan phoneId
                        );
                      },
                      child: Text('Edit'),
                    ),
                    // Tombol Delete
                    ElevatedButton(
                      onPressed: () {
                        ApiService().deletePhone(phone.id).then((_) {
                          Navigator.pop(context); // Kembali ke halaman sebelumnya setelah delete
                        });
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
