import 'package:flutter/material.dart';
import 'package:test/components/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskName = TextEditingController();
  final _myBox = Hive.box('taskbox');

  TaskDatabase db = TaskDatabase();
  
  @override
  void initState() {
    if (_myBox.get("tasksbox") == null) {
      db.createInitData();
    }
    else {
      db.loadData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _taskName.dispose();
    super.dispose();
  }

  void checkBoxChanged(int index) {
      setState(() {
        db.taskList[index][1] = !db.taskList[index][1];
      });
    db.updateData();
  }

  void addTask() {
    setState(() {
      db.taskList.add([_taskName.text, false]);
      Navigator.pop(context);
      _taskName.clear();
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1.0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "To Do",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: db.taskList.length,
        itemBuilder: (BuildContext context, index) {
        return Dismissible(
          onDismissed: (direction) {
            setState(() {
              db.taskList.removeAt(index);
              db.updateData();
            });
          },
          key: Key(db.taskList[index][0]),
          child: Task(
              taskName: db.taskList[index][0],
              checkedOrNot: db.taskList[index][1],
              onChanged: (value) => checkBoxChanged(index)
            )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true, // Allow the modal to adjust height based on content
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Wrap( // Use Wrap to let the modal adjust height based on content
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for the keyboard
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _taskName,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: Colors.black,
                              autofocus: true,
                              onChanged: (text) {
                                setModalState(() {});
                              },
                              decoration: const InputDecoration(
                                hintText: "New Task",
                                border: InputBorder.none,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20, right: 20),
                                child: TextButton(
                                  onPressed: _taskName.text.isEmpty ? null : addTask,
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ).whenComplete(
            () {
              setState(() {
                _taskName.clear();
              });
            }
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}