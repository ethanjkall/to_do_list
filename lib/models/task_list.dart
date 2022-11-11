import 'task.dart';

class TaskList {
  late int id;
  late String name;
  List taskList = <Task>[];

  TaskList(this.name) {
    id = DateTime.now().millisecondsSinceEpoch;
  }

  TaskList.withID(this.id, this.name);

  addTask(String name) {
    taskList.add(Task(name, id));
  }

  addTasks(List<Task> tasks) {
    taskList = tasks;
  }

  removeTask(Task task) {
    taskList.remove(task);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
