import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import '../models/boards.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:http/http.dart' as http;
import "package:pdf/widgets.dart" as p;
import 'package:uuid/uuid.dart';
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
  String color1 = "";

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
          color1 = columns[0].color;
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
      final tmp = doneList.removeAt(oldIndex);
      doneList.insert(newIndex, tmp);
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
                            "http://10.0.2.2:3000/boards/${boardId}/columns/${columnId}/color/${hex}"),
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
                //background: Container(color: Colors.red),
                //onDismissed: (direction) {
                // setState(() {
                // deleteTask(index);
                //doneList.removeAt(index);
                // });
                // },
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  leading: Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        style:
                        TextStyle(
                          decoration: TextDecoration.lineThrough,
                        );
                        isChecked = !value!;
                        //checkBoxListChanged(value, index);
                      }),
                  title: Text(doneList[index].name),
                ),
              );
            },
            itemCount: doneList == null ? 0 : doneList.length,
            onReorder: onReorder));
  }
}
