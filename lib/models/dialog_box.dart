import 'package:big_in_japan/models/my_button.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: Container(
        height: 120,
        child: Column(children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Add a new task",
            ),
          ),
          Row(
            children: [
              MyButton(text: "Save", onPressed: onSave),
              const SizedBox(
                width: 8,
              ),
              MyButton(text: 'Cancel', onPressed: onCancel),
            ],
          )
        ]),
      ),
    );
  }
}
