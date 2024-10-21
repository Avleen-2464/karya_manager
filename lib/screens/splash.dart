import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/theme.dart'; // Assuming this contains your cream color
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Delay of 3 seconds before navigating to the login screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Image.asset(
              'assets/logo1.png',
              width: 250, 
              height: 250,
            ),
                      
          ],
        ),
      ),
    );
  }
}
