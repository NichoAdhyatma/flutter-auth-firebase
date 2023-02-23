import 'package:flutter/material.dart';
import 'package:flutter_auth/pages/auth_page.dart';
import 'package:flutter_auth/providers/auth.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';

import './pages/add_product_page.dart';
import './pages/edit_product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        routes: {
          AddProductPage.route: (ctx) => AddProductPage(),
          EditProductPage.route: (ctx) => const EditProductPage(),
        },
      ),
    );
  }
}
