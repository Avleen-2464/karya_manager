
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:karya_manager/screens/home.dart';
import 'package:karya_manager/screens/register.dart';
import 'package:karya_manager/screens/splash.dart';
import 'firebase_options.dart';
import 'screens/login.dart';



Future<void> main() async {

// ...
WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karya Manager',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/":(context)=>Splash(),
        "/register":(context)=>Register(),
        "/login":(context)=>Login(),
        "/home":(context)=>Home(),

      },
    );
  }
}
