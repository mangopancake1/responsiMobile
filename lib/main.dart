// /lib/main.dart

import 'package:flutter/material.dart';
import 'package:aplication/pages/home_page.dart';
import 'package:aplication/pages/detail_page.dart';
import 'package:aplication/pages/create_page.dart';
import 'package:aplication/pages/edit_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Mendefinisikan routing aplikasi
      initialRoute: '/',  // Halaman awal yang akan ditampilkan
      routes: {
        '/': (context) => HomePage(), // Halaman utama (Home)
        '/create': (context) => CreatePage(), // Halaman untuk membuat ponsel baru
        '/edit': (context) => EditPage(phoneId: ''), // Halaman untuk mengedit ponsel
        '/detail': (context) => DetailPage(phoneId: ''), // Halaman detail ponsel
      },
      // Untuk menangani rute dinamis yang membutuhkan parameter ID
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final phoneId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => EditPage(phoneId: phoneId),
          );
        }
        if (settings.name == '/detail') {
          final phoneId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DetailPage(phoneId: phoneId),
          );
        }
        return null;
      },
    );
  }
}
