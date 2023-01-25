import 'package:big_in_japan/models/users.dart';
import 'package:big_in_japan/views/Done.dart';
import 'package:big_in_japan/views/ToDo.dart';
import 'package:flutter/material.dart';
import 'Now.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../models/boards.dart';

class InitialPage extends StatefulWidget {
  final User user;
  const InitialPage({Key? key, required this.user}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  List pages = [];
  List<Boards> _boards = [];
  int _currentIndex = 0;
  @override
  void initState() {
    // how to make the "build" method wait for the data to avoid temporary exception?
    Future.delayed(Duration.zero, () async {
      print('fetchin boards');
      List<Boards> boards = await fetchBoards(widget.user);

      setState(() {
        pages = [
          ToDo(
            user: widget.user,
            toDoList: boards,
          ),
          Now(
            user: widget.user,
            nowList: boards,
          ),
          Done(
            user: widget.user,
            doneList: boards,
          )
        ];
      });
    });
  }

  fetchBoards(User user) async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/boards"),
      headers: {
        'x-user-id': user.id,
      },
    );
    final responseData = json.decode(response.body);
    final data = responseData.cast<Map<String, dynamic>>();
    List<Boards> boards = [];
    for (var list in data) {
      List<Columns> columns = [];

      for (var column in list["columns"]) {
        List<Tasks> tasks = [];

        for (var task in column["tasks"]) {
          tasks.add(Tasks(id: task["id"], name: task["name"]));
        }
        columns.add(Columns(
            id: column["id"],
            name: column["name"],
            color: column["color"],
            tasks: List.from(tasks)));
      }

      boards.add(Boards(
        id: list["id"],
        name: list["name"],
        color: list["color"],
        owner: list['owner'],
        columns: List.from(columns),
      ));
    }

    return boards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.length > 0 ? pages[_currentIndex] : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel), label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done')
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
