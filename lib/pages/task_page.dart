import 'package:flutter/material.dart';

import '../models/task_list.dart';
import 'package:to_do_list/models/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.currentList});
  final TaskList currentList;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController inputController = TextEditingController();
  bool editMode = false;

  Future<void> _addTaskDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Task'),
            contentPadding: const EdgeInsets.only(top: 10, left: 25, right: 25),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: TextField(
              controller: inputController,
              decoration: const InputDecoration(hintText: 'Enter Task Name'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addTask(inputController.text);
                  },
                  child: const Text('Add')),
            ],
          );
        });
  }

  void _addTask(String taskName) {
    setState(() {
      widget.currentList.addTask(taskName);
    });
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[30],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          widget.currentList.name,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView.builder(
          itemCount: widget.currentList.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            final currentTask = widget.currentList.taskList[index];
            return taskTile(currentTask);
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            _addTaskDialog();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  Container taskTile(Task currentTask) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(3),
        horizontalTitleGap: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Transform.scale(
          scale: 1.3,
          child: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.black,
            value: currentTask.isComplete,
            shape: const CircleBorder(),
            onChanged: (bool? value) {
              setState(() {
                currentTask.isComplete = !currentTask.isComplete;
                value = currentTask.isComplete;
              });
            },
          ),
        ),
        title: Text(currentTask.taskName),
        trailing: editMode
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.currentList.removeTask(currentTask);
                  });
                },
                icon: const Icon(Icons.disabled_by_default_rounded))
            : null,
      ),
    );
  }
}
