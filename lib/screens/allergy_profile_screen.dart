import 'package:flutter/material.dart';

class AllergyProfileScreen extends StatelessWidget {
  final List<String> allergies;

  const AllergyProfileScreen({super.key})
    : allergies = const ['Peanuts', 'Soy', 'Gluten'];

  // Temporary static list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Allergy Profile')),
      body: ListView.builder(
        itemCount: allergies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(allergies[index]),
            trailing: Icon(Icons.warning, color: Colors.red),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add allergy logic
        },
      ),
    );
  }
}
