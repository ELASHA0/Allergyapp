import 'package:flutter/material.dart';
import 'package:allergyapp/screens/allergy_profile_screen.dart'; // Ensure this import path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allergy Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AllergyProfileScreen(), // Ensure 'const' is used here
    );
  }
}
