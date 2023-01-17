


import 'package:big_in_japan/loginscreen.dart';
import 'package:flutter/material.dart';
import 'json_convert1.dart';
import 'json_convert2.dart';
import 'view1.dart';

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
      home: LoginScreen(),
      );
  }
}
