import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/detail_page.dart';
import 'pages/create_page.dart';
import 'pages/edit_page.dart';
import 'pages/favorite_page.dart';

void main() {
  runApp(const PhoneCatalogApp());
}

class PhoneCatalogApp extends StatelessWidget {
  const PhoneCatalogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Catalog',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        CreatePage.routeName: (context) => CreatePage(),
        FavoritePage.routeName: (context) => FavoritePage(),
      },
      onGenerateRoute: (settings) {
        // Cek jika route yang diminta adalah EditPage
        if (settings.name == EditPage.routeName) {
          // Mengambil phoneId dari arguments
          final phoneId = settings.arguments as int?;
          if (phoneId != null) {
            return MaterialPageRoute(
              builder: (context) => EditPage(phoneId: phoneId),
            );
          }
        }

        // Cek jika route yang diminta adalah DetailPage
        else if (settings.name == DetailPage.routeName) {
          final phoneId = settings.arguments as int?;
          if (phoneId != null) {
            return MaterialPageRoute(
              builder: (context) => DetailPage(),
            );
          }
        }

        return null;  // Jika tidak ada yang sesuai, return null.
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
