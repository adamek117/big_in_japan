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
import 'package:http/http.dart' as http;

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
              "http://localhost:3000/boards/${boardId}/columns/${columnId}/tasks/${toDoList[index].id}"),
          headers: {'x-user-id': widget.user.id},
          body: {'columnId': nextColumnId});
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

  bool isChecked = false;
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
        body: ReorderableListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                key: Key('${index}'),
                child: ListTile(
                  leading: Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        checkBoxListChanged(value, index);
                        isChecked = !value!;
                      }),
                  title: Text(toDoList[index].name),
                ),
              );
            },
            itemCount: toDoList == null ? 0 : toDoList.length,
            onReorder: (int oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final tmp = toDoList.removeAt(oldIndex);

                toDoList.insert(newIndex, tmp);
              });
            }));
  }
}
       
          

       
       
      
            
            
            /*Card(
              color: Colors.blueGrey,
              key: ValueKey(items),
              elevation: 2,
              child: ListTile(
                title: Text(items),
                leading: Icon(Icons.work,color: Colors.black,),
              ),
            ),*/
        
      
      
      /*ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            TaskName: toDoList[index].name,
            TaskInProgress: false,
            onChanged: (value) => checkBoxListChanged(value, index),
            deleteFunction: (context) => deleteTask,
          );
        },
      ),*/

