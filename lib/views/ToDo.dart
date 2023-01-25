import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:big_in_japan/models/dialog_box.dart';
import 'package:big_in_japan/models/todo_tile.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'loginscreen.dart';
import 'package:big_in_japan/models/users.dart';
import "InitialPage.dart";

class ToDo extends StatefulWidget {
  final User? user;
  final List<Boards> toDoList;
  const ToDo({Key? key, this.user, required this.toDoList}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List toDoList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.toDoList.length > 0) {
        Boards board = widget.toDoList[0];
        List? columns = board.columns
            ?.where((column) => column.name == 'todo')
            .toList()
            .cast<dynamic>();

        if (columns is List && columns.isNotEmpty) {
          toDoList = List.from(columns[0].tasks);
        }
      }
    });
  }

  final _controller = TextEditingController();

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  void printToPDF() {}
  void changeColor() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("To Do"),
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
              heroTag: "btn1",
              onPressed: printToPDF,
              child: const Icon(Icons.picture_as_pdf),
              backgroundColor: Colors.red,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: changeColor,
              child: const Icon(Icons.change_circle),
              backgroundColor: Colors.lime,
            ),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: createNewTask,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            TaskName: toDoList[index].name,
            TaskInProgress: false,
            onChanged: (value) => checkBoxListChanged(value, index),
            deleteFunction: (context) => deleteTask,
          );
        },
      ),
    );
  }
}
