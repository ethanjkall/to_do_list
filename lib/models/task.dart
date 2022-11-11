class Task {
  late int id;
  late String taskName;
  late bool isComplete;
  late int listId;

  Task(this.taskName, this.listId) {
    id = DateTime.now().millisecondsSinceEpoch;
    isComplete = false;
  }

  Task.withID(this.id, this.taskName, this.isComplete, this.listId);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'isComplete': isComplete ? 1 : 0,
      'listId': listId,
    };
  }
}
