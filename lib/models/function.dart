import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List list = [
    ["Make", false],
  ];
  void deleteTask(int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  void printToPDF() {}
  void changeColor() {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
