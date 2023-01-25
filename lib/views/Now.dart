import 'package:big_in_japan/models/now_tile.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';

class Now extends StatefulWidget {
  final User? user;
  final List<Boards> nowList;
  const Now({Key? key, this.user, required this.nowList}) : super(key: key);

  @override
  State<Now> createState() => _NowState();
}

class _NowState extends State<Now> {
  final _controller = TextEditingController();
  List nowList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.nowList.isNotEmpty) {
        Boards board = widget.nowList[0];
        List? columns = board.columns
            ?.where((column) => column.name == 'in progress')
            .toList()
            .cast<dynamic>();

        if (columns is List && columns.isNotEmpty) {
          nowList = List.from(columns[0].tasks);
        }
      }
    });
  }

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
        title: const Text("In Progress"),
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
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: nowList.length,
        itemBuilder: (context, index) {
          return NowTile(
            TaskName: nowList[index].name,
            TaskDone: false,
            onChanged: (value) => checkBoxListChanged(value, index),
            deleteFunction: (context) => deleteTask,
          );
        },
      ),
    );
  }
}
