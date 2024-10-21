import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karya_manager/models/todo.dart';
import 'package:karya_manager/utils/util.dart';

class TodoService {
  CollectionReference? todos;

  TodoService() {
    todos = FirebaseFirestore.instance.collection("users").doc(Util.uid).collection("todos");
  }
  addTask(ToDoItem item) {
    final todo=todos!.doc();
    item.id=todo.id;
    todo.set(item.toMap());
  }

  deleteTask(id) {
    todos!.doc(id).delete();
  }

  toggleTodo(id) async {
    final doc = await todos!.doc(id).get();
    final task = ToDoItem(task: doc["task"], done: !doc["done"] , id: doc["id"]);
    todos!.doc(id).update(task.toMap());
  }

  Future<List<ToDoItem>> getAll() async {
    final list = await todos!.get();
    List<ToDoItem> todolist = [];
    for (var item in list.docs) {
      todolist.add(ToDoItem.fromMap(item.data() as Map<String, dynamic>));
    }
    return todolist;
  }

  Stream<List<ToDoItem>> getTodoItems() {
    return todos!.snapshots().map((snapshot) {
      return snapshot.docs.map<ToDoItem>((doc) {
        return ToDoItem.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  Future<void> updateTask(String id, String newTask) async {
    try {
      await todos!.doc(id).update({
        'task': newTask, // Update the task field with the new value
      });
      print("Task updated successfully");
    } catch (e) {
      print("Error updating task: $e");
    }
  }
}
