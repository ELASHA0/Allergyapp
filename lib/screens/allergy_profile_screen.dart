import 'package:flutter/material.dart';
import 'package:allergyapp/screens/scan_screen.dart'; // Import ScanScreen

class AllergyProfileScreen extends StatefulWidget {
  const AllergyProfileScreen({super.key});

  @override
  State<AllergyProfileScreen> createState() => _AllergyProfileScreenState();
}

class _AllergyProfileScreenState extends State<AllergyProfileScreen> {
  // Use a mutable list for user allergies
  final List<String> _userAllergies = [
    'Peanuts',
    'Soy',
    'Gluten',
  ]; // Initial static allergies
  final TextEditingController _allergyController = TextEditingController();

  void _addAllergy() {
    final newAllergy = _allergyController.text.trim();
    if (newAllergy.isNotEmpty && !_userAllergies.contains(newAllergy)) {
      setState(() {
        _userAllergies.add(newAllergy);
      });
      _allergyController.clear(); // Clear the input field
    } else if (newAllergy.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an allergy.')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Allergy already exists.')));
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      _userAllergies.remove(allergy);
    });
  }

  @override
  void dispose() {
    _allergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Allergy Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner), // Icon for scanning
            onPressed: () {
              // Navigate to ScanScreen, passing the current allergies
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ScanScreen(userAllergies: _userAllergies),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _allergyController,
                    decoration: InputDecoration(
                      labelText: 'Add New Allergy',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addAllergy(), // Add on pressing Enter
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addAllergy,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _userAllergies.isEmpty
                ? const Center(
                    child: Text(
                      'No allergies added yet. Add some!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _userAllergies.length,
                    itemBuilder: (context, index) {
                      final allergy = _userAllergies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            allergy,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeAllergy(allergy),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
