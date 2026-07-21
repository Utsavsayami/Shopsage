import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopsage_auth_app/views/login_view.dart';
import 'package:shopsage_auth_app/views/vendor_dashboard_view.dart';

void main() {
  runApp(const ShopSageApp());
}

class ShopSageApp extends StatelessWidget {
  const ShopSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShopSage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: LoginView(),
    );
  }
}
