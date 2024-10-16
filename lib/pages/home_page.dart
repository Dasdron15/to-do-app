import 'package:flutter/material.dart';
import 'package:test/components/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskName = TextEditingController();

  @override
  void dispose() {
    _taskName.dispose();
    super.dispose();
  }

  List taskList = [];

  void checkBoxChanged(int index) {
      setState(() {
        taskList[index][1] = !taskList[index][1];
      });
  }

  void addTask() {
    setState(() {
      taskList.add([_taskName.text, false]);
      Navigator.pop(context);
      _taskName.clear();
    });
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
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, index) {
        return Dismissible(
          onDismissed: (direction) {
            setState(() {
              taskList.removeAt(index);
            });
          },
          key: Key(taskList[index][0]),
          child: Task(
              taskName: taskList[index][0],
              checkedOrNot: taskList[index][1],
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
        child: const Icon(Icons.add),
      ),
    );
  }
}