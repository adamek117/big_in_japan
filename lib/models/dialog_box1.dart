import 'package:big_in_japan/models/my_button.dart';
import 'package:flutter/material.dart';

class DialogBox1 extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  VoidCallback defaultColor;
  DialogBox1({
    super.key,
    required this.defaultColor,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Write one color from this pallet: \n Yellow \n Red \n Blue \n Black \n Pink "),
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      content: Container(
        height: 140,
        width: double.infinity,
        child: Column(children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Choose a color",
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    MyButton(text: "Save", onPressed: onSave),
                    const SizedBox(
                      width: 8,
                    ),
                    MyButton(text: 'Cancel', onPressed: onCancel),
                    const SizedBox(
                      width: 8,
                    ),
                    MyButton(text: "Default Color", onPressed: defaultColor),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
