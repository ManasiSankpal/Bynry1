import 'package:bynry1/HomePage.dart';
import 'package:bynry1/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized.
  await Firebase.initializeApp(); // Initialize Firebase.

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
    title: 'Major',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: isLoggedIn ? '/home' : '/login', // Set initial route based on login state
    routes: {
      '/login': (context) => LoginScreen(),
      '/home': (context) => HomeScreen(),
    },
  ));
}
