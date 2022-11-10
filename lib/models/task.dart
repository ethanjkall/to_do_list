class Task {
  late int id;
  late String taskName;
  late bool isComplete;

  Task(this.taskName) {
    id = DateTime.now().millisecondsSinceEpoch;
    isComplete = false;
  }
}
