import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:big_in_japan/models/dialog_box.dart';
import 'package:big_in_japan/models/todo_tile.dart';
import '../models/boards.dart';
import '../models/dialog_box1.dart';
import 'loginscreen.dart';
import 'package:big_in_japan/models/users.dart';
import "InitialPage.dart";
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ToDo extends StatefulWidget {
  final User user;
  final List<Boards> toDoList;
  const ToDo({Key? key, required this.user, required this.toDoList})
      : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List toDoList = [];
  String? boardId;
  String? columnId;
  String? nextColumnId;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.toDoList.isNotEmpty) {
        Boards board = widget.toDoList[0];
        boardId = board.id;
        List? columns = board.columns
            ?.where((column) => column.name == 'todo')
            .toList()
            .cast<dynamic>();
        List? nextColumns = board.columns
            ?.where((column) => column.name == 'in progress')
            .toList()
            .cast<dynamic>();

        if (columns is List &&
            columns.isNotEmpty &&
            nextColumns is List &&
            nextColumns.isNotEmpty) {
          columnId = columns[0].id;
          nextColumnId = nextColumns[0].id;
          toDoList = List.from(columns[0].tasks);
        }
      }
    });
  }

  final _controller = TextEditingController();

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      final response = http.put(
          Uri.parse(
              "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/tasks/${toDoList[index].id}"),
          headers: {'x-user-id': widget.user.id},
          body: {'columnId': nextColumnId});
    });
  }

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();

      // final response = http.post(
      //     Uri.parse(
      //         "http://localhost:3000/boards/${boardId}/columns/${columnId}/tasks/${toDoList[index].name}"),
      //     headers: {'x-user-id': widget.user.id},
      //     body: {''});
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
      final response = http.delete(
        Uri.parse(
            "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/tasks/${toDoList[index].id}"),
        headers: {'x-user-id': widget.user.id},
      );
    });
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final tmp = toDoList.removeAt(oldIndex);
      toDoList.insert(newIndex, tmp);
    });
  }

  void changeColor() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox1(
          controller: _controller,
          defaultColor: defaultColor,
          onSave: saveNewColor,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void defaultColor() {
    setState(() {
      click = Colors.white;
    });
  }

  void saveNewColor() {
    setState(() {
      if (_controller.text == "red") {
        click = Colors.red;
      }
      if (_controller.text == "yellow") {
        click = Colors.yellow;
      }
      if (_controller.text == "blue") {
        click = Colors.blue;
      }
      if (_controller.text == "black") {
        click = Colors.black;
      }
      if (_controller.text == "pink") {
        click = Colors.pink;
      } else {
        const Dialog(child: Text("Wrong color"));
      }
    });
    _controller.clear();
    Navigator.of(context).pop();
  }

  Future<void> printToPDF() async {}
  bool isChecked = false;
  Color click = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: click,
        //backgroundColor: (click == false) ? Colors.red : Colors.white,
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
                backgroundColor: Colors.yellow,
              ),
              FloatingActionButton(
                heroTag: "btn3",
                onPressed: createNewTask,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        body: ReorderableListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key('${index}'),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    setState(() {
                      deleteTask(index);
                    });
                  },
                  child: ListTile(
                    leading: Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          style:
                          TextStyle(
                            decoration: TextDecoration.lineThrough,
                          );
                          checkBoxListChanged(value, index);
                          isChecked = !value!;
                        }),
                    title: Text(toDoList[index].name),
                  ));
            },
            itemCount: toDoList == null ? 0 : toDoList.length,
            onReorder: onReorder));
  }
}
