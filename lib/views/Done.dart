import 'package:big_in_japan/models/dialog_box.dart';
import 'package:big_in_japan/models/done_tile.dart';
import 'package:flutter/material.dart';

class Done extends StatefulWidget {
  const Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  final _controller = TextEditingController();
  List nowList = [
    ["Make", false],
  ];

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      nowList[index][1] = !nowList[index][1];
    });
  }

  void deleteTask(int index) {
    setState(() {
      nowList.removeAt(index);
    });
  }

  void printToPDF() {}
  void changeColor() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Now"),
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: printToPDF,
              child: const Icon(Icons.picture_as_pdf),
              backgroundColor: Colors.red,
            ),
            FloatingActionButton(
              onPressed: changeColor,
              child: const Icon(Icons.change_circle),
              backgroundColor: Colors.lime,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: nowList.length,
        itemBuilder: (context, index) {
          return DoneTile(
            TaskName: nowList[index][0],
            TaskEnd: nowList[index][1],
            onChanged: (value) => checkBoxListChanged(value, index),
            deleteFunction: (context) => deleteTask,
          );
        },
      ),
    );
  }
}
