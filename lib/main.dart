import 'package:flutter/material.dart';
import 'screens/choose_login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Lost & Found',
      theme: AppTheme.lightTheme,
      home: const ChooseLoginScreen(), // ⭐ VERY IMPORTANT
    );
  }
}
