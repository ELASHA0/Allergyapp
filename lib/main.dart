import 'package:flutter/material.dart';
//import 'screens/home_screen.dart';
import 'package:allergyapp/screens/home_screen.dart';

void main() {
  runApp(AllergyApp());
}

class AllergyApp extends StatelessWidget {
  const AllergyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Allergy Identifier',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomeScreen(),
    );
  }
}
