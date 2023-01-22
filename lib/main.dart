import 'package:big_in_japan/views/loginscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big in Japan',
      theme: ThemeData(),
      home: const LoginScreen(),
    );
  }
}
