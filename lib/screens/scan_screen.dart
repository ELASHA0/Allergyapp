import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  final List<String> _userAllergies = ["milk", "peanuts", "soy"];
  String _response = "";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    final uri = Uri.parse("http://10.0.2.2:5000/analyze");
    // 👈 Change to local IP if using real device
    final request = http.MultipartRequest("POST", uri)
      ..fields['allergies'] = _userAllergies.join(',')
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _response = "✅ Image uploaded & analyzed!";
      });
    } else {
      setState(() {
        _response = "❌ Error occurred: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Product Label")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Label"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _analyzeImage,
              child: const Text("Analyze Allergens"),
            ),
            const SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
