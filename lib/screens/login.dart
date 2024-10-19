import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:karya_manager/utils/theme.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late StreamSubscription<User?> _authSubscription;
  String? error;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Check if mounted before navigating
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel(); // Cancel the subscription to prevent memory leaks
    emailController.dispose(); // Dispose controllers
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
  // Check if email and password fields are empty
  if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
    setState(() {
      error = 'Please fill in both fields.'; // Display error message
    });
    return; // Exit the method early
  }
  setState(() {
    isLoading=true;
  });

  try {
    // Attempt to sign in
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Only navigate to home if login is successful
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      // Debugging: Print the caught error code
      print("Firebase Auth Error: ${e.code}");

      // Handle specific Firebase authentication errors
      switch (e.code) {
        case 'user-not-found':
          error = 'No user found for that email.';
          break;
        case 'wrong-password':
          error = 'Wrong password provided for that user.';
          break;
        case 'invalid-credential':
          error = 'Invalid credentials provided. Please check your email and password.';
          break;
        default:
          error = 'An error occurred. Please try again.';
          break;
      }
    });
  } catch (e) {
    setState(() {
      error = 'An unexpected error occurred: $e'; // Handle unexpected errors
    });
    print("Unexpected Error: $e"); // Debugging statement
  }
  finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:cream, // #f9eed8 background
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: black), // #231d20
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: black), // #231d20
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Text
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color:black, // #231d20
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Email TextField
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: black),
                prefixIcon: const Icon(Icons.email, color:black),
                filled: true,
                fillColor: pink, // #fb8da8
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Password TextField
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: black),
                prefixIcon: const Icon(Icons.lock, color: black),
                filled: true,
                fillColor:pink, // #fb8da8
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 40),

            // Login Button
            isLoading?const Center(child: CircularProgressIndicator(),):
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Smaller padding
                backgroundColor:black, // Ensure you have this color defined
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 16, color:cream), // Adjusted font size
              ),
            ),

            const SizedBox(height: 20),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),

            // Register Button
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/register");
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: const BorderSide(color:blue), // #1968e8
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "New User? Register Here",
                style: TextStyle(
                  fontSize: 18,
                  color: blue, // #1968e8
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
