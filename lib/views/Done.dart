import 'package:big_in_japan/models/done_tile.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:http/http.dart' as http;

class Done extends StatefulWidget {
  final User user;
  final List<Boards> doneList;
  const Done({Key? key, required this.user, required this.doneList})
      : super(key: key);

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  final _controller = TextEditingController();
  List doneList = [];
  String? boardId;
  String? columnId;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.doneList.isNotEmpty) {
        Boards board = widget.doneList[0];
        boardId = board.id;
        List? columns = board.columns
            ?.where((column) => column.name == 'done')
            .toList()
            .cast<dynamic>();

        if (columns is List && columns.isNotEmpty) {
          columnId = columns[0].id;
          doneList = List.from(columns[0].tasks);
        }
      }
    });
  }

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      final response = http.delete(
        Uri.parse(
            "http://localhost:3000/boards/${boardId}/columns/${columnId}/tasks/${doneList[index].id}"),
        headers: {'x-user-id': widget.user.id},
      );
    });
  }

  void deleteTask(int index) {
    setState(() {
      doneList.removeAt(index);
    });
  }

  void printToPDF() {}
  bool isChecked = false;
  bool click = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: (click == false) ? Colors.blue : Colors.white,
        appBar: AppBar(
          title: const Text("Done"),
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
                  title: Text(doneList[index].name),
                ),
              );
            },
            itemCount: doneList == null ? 0 : doneList.length,
            onReorder: (int oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final tmp = doneList.removeAt(oldIndex);

                doneList.insert(newIndex, tmp);
              });
            }));
  }
}
