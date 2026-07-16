import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(const ShopSageApp());
}

class ShopSageApp extends StatelessWidget {
  const ShopSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopSage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const LoginView(),
    );
  }
}
