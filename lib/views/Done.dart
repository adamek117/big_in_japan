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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text("To Do"),
        elevation: 0,
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
