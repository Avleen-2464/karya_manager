import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karya_manager/models/todo.dart';
import 'package:karya_manager/services/todo_service.dart';
import 'package:karya_manager/services/userService.dart'; 
import 'package:karya_manager/utils/theme.dart';
import 'package:karya_manager/utils/util.dart';
import 'package:karya_manager/models/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDoItem> todos = [];
  TodoService service = TodoService();
  Userservice userservice = Userservice();
  AppUser? currentUser; // Variable to hold current user data

  @override
  void initState() {
    super.initState();
    service.getTodoItems().listen((e) {
      setState(() {
        todos = e;
      });
    });
    fetchUserData();
  }

  // Fetch user data from Firestore
  void fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid; // Get the current user's uid
    if (uid != null) {
      try {
        currentUser = await userservice.getUserFromDatabase(uid); // Fetch user data
        if (currentUser == null) {
          print("User not found in Firestore.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
      setState(() {}); // Update the UI
    } else {
      print("No user is logged in");
    }
  }

  TextEditingController taskController = TextEditingController();

  // Method to add task
  void addToList(context) {
    if (taskController.text.trim().isNotEmpty) {
      setState(() {
        service.addTask(ToDoItem(task: taskController.text.trim(), done: false, id: null));
      });
    }
    Navigator.of(context).pop();
  }

  // Method to remove task
  void removeFromList(int index) {
    setState(() {
      service.deleteTask(todos[index].id);
    });
  }

  // Method to toggle task completion
  void toggleCheck(int index) {
    setState(() {
      service.toggleTodo(todos[index].id);
    });
  }

  // Method to edit a task
  void editTask(int index) {
    taskController.text = todos[index].task; // Prefill the task field with the current task

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Task", style: TextStyle(fontSize: 20)),
              TextField(
                decoration: const InputDecoration(labelText: "Enter task"),
                controller: taskController,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      service.updateTask(todos[index].id!, taskController.text.trim());
                      Navigator.of(context).pop();
                    },
                    child: const Text("Update"),
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

  // Dialog to add a new task
  void addTodo() {
    taskController.clear(); // Clear the controller before adding a new task
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
                controller: taskController,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => addToList(context),
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
            icon: const Icon(Icons.logout),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // User Profile Information
            Text(
              'Email: ${currentUser?.email ?? "user@example.com"}', // Display the user's email or a placeholder if null
              style: const TextStyle(fontSize: 16),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // Decorative text style
                      ),
                      leading: Checkbox(
                        value: todos[index].done,
                        onChanged: (_) {
                          toggleCheck(index);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit), // Edit icon
                            onPressed: () => editTask(index), // Call editTask method
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove), // Remove icon
                            onPressed: () => removeFromList(index), // Call remove method
                          ),
                        ],
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
