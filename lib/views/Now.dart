import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:http/http.dart' as http;
import "package:pdf/widgets.dart" as p;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:string_to_color/string_to_color.dart';

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
  String color1 = "";

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
          color1 = columns[0].color;
        }
      }
    });
  }

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      final response = http.put(
          Uri.parse(
              "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/tasks/${nowList[index].id}"),
          headers: {'x-user-id': widget.user.id},
          body: {'columnId': nextColumnId});
    });
  }

  void deleteTask(int index) {
    setState(() {
      final response = http.delete(
        Uri.parse(
            "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/tasks/${nowList[index].id}"),
        headers: {'x-user-id': widget.user.id},
      );
    });
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final int item = nowList.removeAt(oldIndex);
      nowList.insert(newIndex, item);
      /*final tmp = nowList.removeAt(oldIndex);
      nowList.insert(newIndex, tmp);*/
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
                borderColor: mycolor, //default color
                onColorChanged: (Color color) {
                  //on color picked
                  setState(() {
                    mycolor = color;
                    hex = '#${mycolor.value.toRadixString(16)}';
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
                        body: {'color': hex});
                  });
                  Navigator.of(context).pop(); //dismiss the color picker
                },
              ),
            ],
          );
        });
  }

  Future<void> printToPDF() async {
    List<p.Widget> widgets = [];
    widgets.add(
      p.Text(
        "To do Tasks of user",
        style: p.TextStyle(fontSize: 25, fontWeight: p.FontWeight.bold),
      ),
    );
    widgets.add(p.SizedBox(height: 15));
    for (int i = 0; i < nowList.length; i++) {
      String task = nowList[i].name.toString();
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
    Navigator.of(context).pop();
    Printing.layoutPdf(
      name: "Tasks of users",
      onLayout: (PdfPageFormat) async => pdf.save(),
    );
  }

  bool isChecked = false;
  Color mycolor = Colors.white;
  var hex;
  @override
  Widget build(BuildContext context) {
    mycolor = ColorUtils.stringToColor(color1);
    return Scaffold(
        backgroundColor: mycolor,
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
                child: const Icon(Icons.colorize),
                backgroundColor: Colors.lime,
              ),
            ],
          ),
        ),
        body: ReorderableListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                key: ValueKey(index),
                //background: Container(color: Colors.red),
                //onDismissed: (direction) {
                // setState(() {
                // deleteTask(index);
                // });
                //},
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
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex > oldIndex) {
                newIndex-- - 1;
              }
              setState(() {
                final item = nowList[oldIndex].name;
                nowList.removeAt(oldIndex);
                nowList.insert(newIndex, item);
              });
            }));
  }
}
