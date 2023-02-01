import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:big_in_japan/models/dialog_box.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import "package:pdf/widgets.dart" as p;
import 'package:uuid/uuid.dart';
import 'package:string_to_color/string_to_color.dart';

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
  Color columnColor = Colors.white;

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
          columnColor = Color(int.parse(columns[0].color));
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
      Tasks? task = toDoList.removeAt(index);

      if (task != null) {
        widget.toDoList[0].columns?[0].tasks?.removeAt(index);
        widget.toDoList[0].columns?[1].tasks?.add(task);
      }
    });
  }

  void saveNewTask() {
    setState(() {
      final task = Tasks(id: Uuid().v4(), name: _controller.text);
      toDoList.add(task);
      widget.toDoList[0].columns?[0].tasks?.add(task);
      _controller.clear();

      final response = http.post(
          Uri.parse(
              "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}"),
          headers: {'x-user-id': widget.user.id},
          body: {'id': task.id, 'name': task.name});
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
      final int item = toDoList.removeAt(oldIndex);
      toDoList.insert(newIndex, item);
    });
  }

  void changeColor() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                borderColor: columnColor, //default color
                onColorChanged: (Color color) {
                  //on color picked
                  setState(() {
                    widget.toDoList[0].columns?[0].color =
                        color.value.toString();
                    columnColor = color;
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('DONE'),
                onPressed: () {
                  setState(() {
                    final response = http.put(
                        Uri.parse(
                            "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}"),
                        headers: {'x-user-id': widget.user.id},
                        body: {'color': columnColor.value.toString()});
                  });
                  Navigator.of(context).pop(); //dismiss the color picker
                },
              ),
            ],
          );
        });
  }

  /*Future<void> printToPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    page.graphics.drawString(
        "To Do tasks of user", PdfStandardFont(PdfFontFamily.helvetica, 30));

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 1);
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Tasks';
    PdfGridRow row = grid.rows.add();
    if (toDoList.isNotEmpty) {
      row.cells[0].value = "";
    } else {
      row.cells[0].value = "No data to show";
    }
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.aliceBlue,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.helvetica, 20));
    grid.draw(
        page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
    List<int> bytes = document.saveSync();
    document.dispose();

    saveAndLaunchFile(bytes, 'Output.pdf');
  }*/

  Future<void> printToPDF() async {
    List<p.Widget> widgets = [];
    widgets.add(
      p.Text(
        "To do Tasks of user",
        style: p.TextStyle(fontSize: 25, fontWeight: p.FontWeight.bold),
      ),
    );
    widgets.add(p.SizedBox(height: 15));
    for (int i = 0; i < toDoList.length; i++) {
      String task = toDoList[i].name.toString();
      widgets.add(
        p.Text(
          task,
          style: const p.TextStyle(color: PdfColors.black, fontSize: 15),
        ),
      );
      widgets.add(p.SizedBox(height: 10));
    }
    final pdf = p.Document();
    pdf.addPage(
      p.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets,
      ),
    );
    Printing.layoutPdf(
      name: "Tasks of users",
      onLayout: (PdfPageFormat) async => pdf.save(),
    );
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: columnColor,
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
              backgroundColor: Colors.red,
              child: const Icon(Icons.picture_as_pdf),
            ),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: createNewTask,
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: changeColor,
              backgroundColor: Colors.lime,
              child: const Icon(Icons.colorize),
            ),
          ],
        ),
      ),
      body: ReorderableListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key('${index}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                deleteTask(index);
                toDoList.removeAt(index);
              });
            },
            child: Card(
              child: ListTile(
                leading: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      checkBoxListChanged(value, index);
                      isChecked = !value!;
                    }),
                title: Text(toDoList[index].name),
                hoverColor: Colors.blue,
              ),
            ),
          );
        },
        itemCount: toDoList == null ? 0 : toDoList.length,
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = toDoList[oldIndex].name;
          toDoList.removeAt(oldIndex);
          toDoList.insert(newIndex, item);
        },
      ),
    );
  }
}
