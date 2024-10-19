import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:karya_manager/models/todo.dart";
import 'package:karya_manager/services/todo_service.dart';

import "../utils/util.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDoItem> todos = [];
  TodoService service = TodoService();
  @override
  void initState() {
    super.initState();
    service.getTodoItems().listen((e) {
      setState(() {
        todos = e;
      });
    });
  }

  addtolist(context) {
    setState(() {
      service.addTask(ToDoItem(task: task.text.trim(), done: false, id: null));
    });
    Navigator.of(context).pop();
  }

  removerFromList(index) {
    setState(() {
      service.deleteTask(todos[index].id);
    });
  }

  toggleCheck(index) {
    setState(() {
      service.toggleTodo(todos[index].id);
    });
  }

  TextEditingController task = TextEditingController();
  addTodo() {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                children: [
                  const Text("Add task"),
                  TextField(
                    decoration: const InputDecoration(labelText: "Enter task"),
                    controller: task,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => addtolist(context),
                          child: const Text("Add")),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_off),
            onPressed: () => {
              FirebaseAuth.instance.signOut(),
              Navigator.pushReplacementNamed(context, "/login"),
              Util.uid=null

            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(todos[index].task),
              leading: Checkbox(
                value: todos[index].done,
                onChanged: (_) {
                  toggleCheck(index);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => removerFromList(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
