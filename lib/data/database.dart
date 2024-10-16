import 'package:hive_flutter/hive_flutter.dart';

class TaskDatabase {
  List taskList = [];

  final _myBox = Hive.box('taskbox');

  void createInitData() {
    taskList = [];
  }

  void loadData() {
    taskList = _myBox.get("tasksbox");
  }

  void updateData() {
    _myBox.put("tasksbox", taskList);
  }
}