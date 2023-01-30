import 'package:big_in_japan/models/now_tile.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:http/http.dart' as http;

class Now extends StatefulWidget {
  final User user;
  final List<Boards> nowList;
  const Now({Key? key, required this.user, required this.nowList})
      : super(key: key);

  @override
  State<Now> createState() => _NowState();
}

class _NowState extends State<Now> {
  final _controller = TextEditingController();
  List nowList = [];
  String? boardId;
  String? columnId;
  String? nextColumnId;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.nowList.isNotEmpty) {
        Boards board = widget.nowList[0];
        boardId = board.id;
        List? columns = board.columns
            ?.where((column) => column.name == 'in progress')
            .toList()
            .cast<dynamic>();
        List? nextColumns = board.columns
            ?.where((column) => column.name == 'done')
            .toList()
            .cast<dynamic>();

        if (columns is List &&
            columns.isNotEmpty &&
            nextColumns is List &&
            nextColumns.isNotEmpty) {
          columnId = columns[0].id;
          nextColumnId = nextColumns[0].id;
          nowList = List.from(columns[0].tasks);
        }
      }
    });
  }

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      final response = http.put(
          Uri.parse(
              "http://localhost:3000/boards/${boardId}/columns/${columnId}/tasks/${nowList[index].id}"),
          headers: {'x-user-id': widget.user.id},
          body: {'columnId': nextColumnId});
    });
  }

  void deleteTask(int index) {
    setState(() {
      nowList.removeAt(index);
    });
  }

  void printToPDF() {}
  bool isChecked = false;

  bool click = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: (click == false) ? Colors.yellow : Colors.white,
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
                onPressed: () {
                  setState(() {
                    click = !click;
                  });
                },
                child: const Icon(Icons.change_circle),
                backgroundColor: Colors.lime,
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
                  title: Text(nowList[index].name),
                ),
              );
            },
            itemCount: nowList == null ? 0 : nowList.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final tmp = nowList.removeAt(oldIndex);

                nowList.insert(newIndex, tmp);
              });
            }));
  }
}
