import 'package:flutter/material.dart';
import '../main.dart';
import '../loginscreen.dart';
import 'Now.dart';
import 'ToDo.dart';

class Done extends StatelessWidget {
  // up buttonSection
  @override
  Widget build(BuildContext context) {
    String task = "";
    var _controller = TextEditingController();

    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            /* Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));*/
          },
          child: const Text('Wyloguj się'),
        ),
        ElevatedButton.icon(
            icon: Icon(Icons.picture_as_pdf),
            label: Text('Wyeksportuj do PDF-a'),
            onPressed: () {
              print("Wyeksportowałeś do PDF-a");
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white)),
        ElevatedButton.icon(
            icon: Icon(Icons.format_color_fill),
            label: Text('Zmień kolor'),
            onPressed: () {
              print("Funkcja odpowiedzialna za zmiane koloru");
            }),
        ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Dodaj Taska'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white)),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Admin'),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey,
        ),
        body: Column(
          children: [
            buttonSection,
          ],
        ),
      ),
    );
  }
}
