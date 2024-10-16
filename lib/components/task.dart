import 'package:flutter/material.dart';
import 'package:animated_line_through/animated_line_through.dart';

// ignore: must_be_immutable
class Task extends StatefulWidget {
  final String taskName;
  final bool checkedOrNot;
  Function(bool?)? onChanged;

  Task({super.key, required this.taskName, required this.checkedOrNot, required this.onChanged,});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 0
      ),
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: widget.checkedOrNot ? const Color.fromRGBO(227, 227, 227, 1.0) : Colors.white),
      child: Row(
        children: [
          Checkbox(value: widget.checkedOrNot, onChanged: widget.onChanged, activeColor: Colors.green),

          Flexible(
            child: AnimatedLineThrough(
              isCrossed: widget.checkedOrNot,
              strokeWidth: 2,
              duration: const Duration(milliseconds: 100),
              
              child: Text(widget.taskName,style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ))
            ),
          ),
        ],
      ),
    );
  }
}