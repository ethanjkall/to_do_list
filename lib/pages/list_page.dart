import 'package:flutter/material.dart';
import 'package:to_do_list/models/database.dart';

import '../models/task_list.dart';
import 'task_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<TaskList> lists = <TaskList>[];
  TaskList? currentList;
  TextEditingController inputController = TextEditingController();
  bool editMode = false;
  var db = DatabaseConnect();

  Future<void> _addListDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add List'),
            contentPadding: const EdgeInsets.only(top: 10, left: 25, right: 25),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: TextField(
              controller: inputController,
              decoration: const InputDecoration(hintText: 'Enter List Name'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addList(inputController.text);
                  },
                  child: const Text('ADD')),
            ],
          );
        });
  }

  void _addList(String name) async {
    await db.insertList(TaskList(name));
    _getLists();
    setState(() {});
    inputController.clear();
  }

  void _removeList(TaskList list) async {
    await db.deleteList(list);
    _getLists();
    setState(() {});
  }

  void _getLists() async {
    lists = await db.getLists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _getLists();
    return Scaffold(
      backgroundColor: Colors.lightBlue[30],
      appBar: AppBar(
        title: const Text('Your Lists',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 27)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
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
          itemCount: lists.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                tileColor: Colors.white,
                title: Text(lists[index].name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54)),
                onTap: () {
                  setState(() {
                    currentList = lists[index];
                  });
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return TaskPage(currentList: lists[index]);
                  }));
                },
                //contentPadding: const EdgeInsets.only(left: 20, right: 1),
                trailing: editMode
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _removeList(lists[index]);
                          });
                        },
                        icon: const Icon(Icons.disabled_by_default_rounded))
                    : const Icon(
                        Icons.arrow_forward_ios,
                      ));
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _addListDialog();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
