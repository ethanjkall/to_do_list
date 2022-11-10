import 'task.dart';

class TaskList {
  late String name;
  final taskList = <Task>[];

  TaskList(this.name);

  addTask(String name) {
    taskList.add(Task(name));
  }

  removeTask(Task task) {
    taskList.remove(task);
  }
}
