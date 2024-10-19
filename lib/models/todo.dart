class ToDoItem {
  String task;
  bool done;
  String? id;

  ToDoItem({required this.task, required this.done , required this.id});

  toMap() {
    return {"task": task, "done": done , "id": id};
  }
  static fromMap(Map<String, dynamic> map)
  {
    return ToDoItem(task: map["task"], done: map["done"] , id: map["id"]);
  }
}