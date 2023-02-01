import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:http/http.dart' as http;
import "package:pdf/widgets.dart" as p;
import 'package:string_to_color/string_to_color.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

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
  Color columnColor = Colors.white;

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
          columnColor = Color(int.parse(columns[0].color));
        }
      }
    });
  }

  void checkBoxListChanged(bool? value, int index) {
    setState(() {
      final response = http.delete(
        Uri.parse(
            "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/tasks/${doneList[index].id}"),
        headers: {'x-user-id': widget.user.id},
      );
      doneList.removeAt(index);
      widget.doneList[0].columns?[2].tasks?.removeAt(index);
    });
  }

  void deleteTask(int index) {
    setState(() {
      final response = http.delete(
        Uri.parse(
            "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/tasks/${doneList[index].id}"),
        headers: {'x-user-id': widget.user.id},
      );
    });
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final int item = doneList.removeAt(oldIndex);
      doneList.insert(newIndex, item);
      /*final tmp = doneList.removeAt(oldIndex);
      doneList.insert(newIndex, tmp);*/
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
                    widget.doneList[0].columns?[2].color =
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

  Future<void> printToPDF() async {
    List<p.Widget> widgets = [];
    widgets.add(
      p.Text(
        "To do Tasks of user",
        style: p.TextStyle(fontSize: 25, fontWeight: p.FontWeight.bold),
      ),
    );
    widgets.add(p.SizedBox(height: 15));
    for (int i = 0; i < doneList.length; i++) {
      String task = doneList[i].name.toString();
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
              onPressed: changeColor,
              child: const Icon(Icons.colorize),
              backgroundColor: Colors.lime,
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
                doneList.removeAt(index);
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
                title: Text(doneList[index].name),
                hoverColor: Colors.blue,
              ),
            ),
          );
        },
        itemCount: doneList == null ? 0 : doneList.length,
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = doneList[oldIndex].name;
          doneList.removeAt(oldIndex);
          doneList.insert(newIndex, item);
        },
      ),
    );
  }
}
