import 'package:flutter/material.dart';
import 'package:to_do_list/models/task_list.dart';
import 'package:to_do_list/pages/list_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: const ListPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final lists = <TaskList>[
    TaskList('Home'),
    TaskList('Work'),
    TaskList('School')
  ];
  var currentList = TaskList('Debug');
  TextEditingController inputController = TextEditingController();
  bool editMode = false;

  Future<void> _addTaskDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: TextField(
              controller: inputController,
              decoration: const InputDecoration(hintText: 'Add a Task'),
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

  Future<void> _addListDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add List'),
            content: TextField(
              controller: inputController,
              decoration: const InputDecoration(hintText: 'Add a List'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addList(inputController.text);
                  },
                  child: const Text('List')),
            ],
          );
        });
  }

  void _addTask(String taskName) {
    setState(() {
      currentList.addTask(taskName);
    });
    inputController.clear();
  }

  void _addList(String name) {
    setState(() {
      lists.add(TaskList(name));
    });
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Lists')),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(lists[index].name),
                      onTap: () {
                        setState(() {
                          currentList = lists[index];
                        });
                        Navigator.pop(context);
                      },
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              lists.remove(lists[index]);
                            });
                          },
                          icon: const Icon(Icons.delete)));
                }),
            TextButton(
                onPressed: () {
                  _addListDialog();
                },
                child: const Text('Add List'))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(currentList.name),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: ListView.builder(
          itemCount: currentList.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            final currentTask = currentList.taskList[index];
            return ListTile(
              leading: Checkbox(
                checkColor: Colors.white,
                value: currentTask.isComplete,
                shape: const CircleBorder(),
                onChanged: (bool? value) {
                  setState(() {
                    currentTask.isComplete = !currentTask.isComplete;
                    value = currentTask.isComplete;
                  });
                },
              ),
              title: Text(currentTask.taskName),
              trailing: editMode
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          currentList.removeTask(currentTask);
                        });
                      },
                      icon: const Icon(Icons.delete))
                  : null,
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTaskDialog();
          },
          child: const Icon(Icons.add)),
    );
  }
}
