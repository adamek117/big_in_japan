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
  // List<Boards> boards = [];

  @override
  void initState() {
    super.initState();
    //getRequest();
    //futureUser = fetchUser();
    //getJsonData();
  }

  // Future<void> getRequest() async {
  //   final response = await http.get(
  //     Uri.parse("http://localhost:3000/boards"),
  //     headers: {
  //       'x-user-id': 'ddfcdaea-9e9f-47cf-bd64-bcaabd39eef7',
  //     },
  //   );
  //   final responseData = json.decode(response.body);
  //   final data = responseData.cast<Map<String, dynamic>>();
  //   setState(() {
  //     for (var list in data) {
  //       Boards user1 = Boards(
  //         id: list["id"],
  //         name: list["name"],
  //         color: list["color"],
  //         owner: list['owner'],
  //       );
  //       boards.add(user1);
  //     }
  //   });
  // }
  /*
    String url1 = "http://localhost:3000/boards";
    final response1 = await http.get(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: 'a43b3af3-c099-43b8-80da-fbe4613db542',
    });
    
    var responseData1 = json.decode(response.body);
    final data1 = responseData.cast<Map<String, dynamic>>();
    setState(() {});
  }**/

  final _controller = TextEditingController();
  List toDoList = [
    ["Make", false],
  ];

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
            TaskName: toDoList[index][0],
            TaskInProgress: toDoList[index][1],
            onChanged: (value) => checkBoxListChanged(value, index),
            deleteFunction: (context) => deleteTask,
          );
        },
      ),
    );
  }
}
