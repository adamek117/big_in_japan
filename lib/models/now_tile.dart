import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NowTile extends StatelessWidget {
  final String TaskName;
  final bool TaskDone;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  NowTile({
    super.key,
    required this.TaskName,
    required this.TaskDone,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: TaskDone,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              Text(TaskName),
            ],
          ),
        ),
      ),
    );
  }
}
