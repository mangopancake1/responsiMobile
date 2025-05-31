import 'package:flutter/material.dart';
import 'pages/phone_catalog_page.dart';
import 'pages/phone_detail_page.dart';
import 'pages/add_phone_page.dart';
import 'pages/update_phone_page.dart';
import 'pages/favorite_phones_page.dart';

void main() {
  runApp(const PhoneCatalogApp());
}

class PhoneCatalogApp extends StatelessWidget {
  const PhoneCatalogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: PhoneCatalogPage.routeName,
      routes: {
        PhoneCatalogPage.routeName: (context) => const PhoneCatalogPage(),
        PhoneDetailPage.routeName: (context) => const PhoneDetailPage(),
        AddPhonePage.routeName: (context) => const AddPhonePage(),
        UpdatePhonePage.routeName: (context) => const UpdatePhonePage(),
        FavoritePhonesPage.routeName: (context) => const FavoritePhonesPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
