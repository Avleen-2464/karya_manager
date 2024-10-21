import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karya_manager/models/user.dart';
import 'package:karya_manager/services/userService.dart';
import 'package:karya_manager/utils/theme.dart'; // Ensure you have theme colors

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? error;
  bool isLoading = false;
  Userservice service = Userservice();

  signIn() async {
    setState(() {
      error = null;
    });

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        error = "Passwords do not match";
      });
      return;
    }
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = AppUser(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
      );
      await service.addUserToDatabase(user, credential.user!.uid);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            error = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            error = 'The account already exists for that email.';
            break;
          default:
            error = 'An unknown error occurred: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        error = 'An unexpected error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream, // #f9eed8 background
      appBar: AppBar(
        title: const Text(
          "Karya Manager",
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
            // Logo
            Image.asset(
              'assets/logo2.png', // Change this to the logo you want to display
              height: 100, // Adjust height as needed
            ),
            const SizedBox(height: 20),

            // Welcome Text
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: black, // #231d20
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Name TextField
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: const TextStyle(color: black),
                prefixIcon: const Icon(Icons.person, color: black),
                filled: true,
                fillColor: pink, // #fb8da8
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: nameController,
            ),
            const SizedBox(height: 20),

            // Email TextField
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: black),
                prefixIcon: const Icon(Icons.email, color: black),
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
                fillColor: pink, // #fb8da8
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Confirm Password TextField
            TextField(
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: const TextStyle(color: black),
                prefixIcon: const Icon(Icons.lock, color: black),
                filled: true,
                fillColor: pink, // #fb8da8
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 40),

            // Register Button
            isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                backgroundColor: black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 16, color: cream),
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

            // Login Button
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: blue), // #1968e8
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Already a User? Login Here",
                style: TextStyle(
                  fontSize: 12,
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
