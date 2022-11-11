import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'task.dart';
import 'task_list.dart';

class DatabaseConnect {
  Database? _database;

  Future<Database> get database async {
    final dbpath = await getDatabasesPath();
    const dbname = 'todolist.db';
    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE task(id INTEGER PRIMARY KEY, taskName TEXT,isComplete INTEGER, listId INTEGER)');

    await db
        .execute('CREATE TABLE taskList(id INTEGER PRIMARY KEY, name TEXT)');
  }

  Future<void> insertList(TaskList list) async {
    final db = await database;

    await db.insert(
      'taskList',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTask(Task task) async {
    final db = await database;

    await db.insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteList(TaskList list) async {
    final db = await database;

    await db.delete(
      'taskList',
      where: 'id == ?',
      whereArgs: [list.id],
    );
  }

  Future<void> deleteTask(Task task) async {
    final db = await database;

    await db.delete(
      'task',
      where: 'id == ?',
      whereArgs: [task.id],
    );
  }

  Future<void> toggleTask(int id, bool isComplete) async {
    final db = await database;

    // if true, then update table with false, vice versa
    int completed = isComplete ? 0 : 1;

    await db.update(
      'task', // table name
      {
        //
        'isComplete': completed, // data we have to update
      }, //
      where: 'id == ?', // which Row we have to update
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasks(int id) async {
    final db = await database;

    List<Map<String, dynamic>> items = await db.query(
      'task',
      orderBy: 'id ASC',
    );

    List<Task> tasks = [];

    for (int i = 0; i < items.length; i++) {
      if (items[i]['listId'] == id) {
        Task task = Task.withID(items[i]['id'], items[i]['taskName'],
            items[i]['isComplete'] == 1 ? true : false, items[i]['listId']);
        tasks.add(task);
      }
    }

    return tasks;
  }

  Future<List<TaskList>> getLists() async {
    final db = await database;

    List<Map<String, dynamic>> items = await db.query(
      'taskList',
      orderBy: 'id ASC',
    );

    List<TaskList> lists = [];

    for (int i = 0; i < items.length; i++) {
      TaskList list = TaskList.withID(items[i]['id'], items[i]['name']);
      list.taskList = await getTasks(items[i]['id']);
      lists.add(list);
    }

    return lists;
  }
}
