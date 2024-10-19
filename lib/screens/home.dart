import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:karya_manager/models/todo.dart";
import 'package:karya_manager/services/todo_service.dart';
import 'package:karya_manager/services/userService.dart'; // Import UserService
import "package:karya_manager/utils/theme.dart";
import "../utils/util.dart";
import 'package:karya_manager/models/user.dart'; // Import AppUser model

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDoItem> todos = [];
  TodoService service = TodoService();
  Userservice userservice = Userservice(); // Instantiate UserService
  AppUser? currentUser; // Variable to hold current user data

  @override
  void initState() {
    super.initState();
    service.getTodoItems().listen((e) {
      setState(() {
        todos = e;
      });
    });
    fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Fetch user data from Firestore
  void fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid; // Get the current user's uid
    print("Current User UID: $uid"); // Debug log
    if (uid != null) {
      try {
        currentUser = await userservice.getUserFromDatabase(uid); // Fetch user data
        print("Fetched User: $currentUser"); // Debug log
        if (currentUser == null) {
          print("User not found in Firestore."); // Debug log
        }
      } catch (e) {
        print("Error fetching user data: $e"); // Catch any errors
      }
      setState(() {}); // Update the UI
    } else {
      print("No user is logged in"); // Debug log
    }
  }

  TextEditingController task = TextEditingController();

  // Method to add task
  void addtolist(context) {
    setState(() {
      service.addTask(ToDoItem(task: task.text.trim(), done: false, id: null));
    });
    Navigator.of(context).pop();
  }

  // Method to remove task
  void removerFromList(index) {
    setState(() {
      service.deleteTask(todos[index].id);
    });
  }

  // Method to toggle task completion
  void toggleCheck(index) {
    setState(() {
      service.toggleTodo(todos[index].id);
    });
  }

  // Dialog to add new task
  void addTodo() {
    task.clear();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Task", style: TextStyle(fontSize: 20)),
              TextField(
                decoration: const InputDecoration(labelText: "Enter task"),
                controller: task,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => addtolist(context),
                    child: const Text("Add"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        backgroundColor: pink, // Use pink color from theme
        actions: [
          IconButton(
            icon: const Icon(Icons.power_off),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
              Util.uid = null;
            },
          ),
        ],
      ),
      body: Container(
        color: cream, // Set background color to cream
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              'Welcome, ${currentUser?.name ?? "User"}!', // Display the user's name or "User" if null
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // User Profile Information
            Text(
              'Email: ${currentUser?.email ?? "user@example.com"}', // Display the user's email or a placeholder if null
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Recent Activities Header
            const Text(
              'Recent Activities:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Card( // Use Card to decorate task items
                    elevation: 4, // Add shadow
                    margin: const EdgeInsets.symmetric(vertical: 8), // Space between cards
                    child: ListTile(
                      title: Text(
                        todos[index].task,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // Decorative text style
                      ),
                      leading: Checkbox(
                        value: todos[index].done,
                        onChanged: (_) {
                          toggleCheck(index);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => removerFromList(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        backgroundColor: pink, // Use pink color from theme
        child: const Icon(Icons.add),
      ),
    );
  }
}
