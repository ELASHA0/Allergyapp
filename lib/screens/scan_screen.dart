import 'dart:io';
import 'package:allergyapp/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  final List<String> userAllergies; // New: Receive user allergies

  const ScanScreen({
    super.key,
    required this.userAllergies,
  }); // Updated constructor

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image; // Stores the captured image file
  bool _isLoading =
      false; // State variable to track if an analysis is in progress

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality:
          80, // Reduce image quality to save bandwidth and speed up upload
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image file in state
      });
    }
  }

  Future<void> _analyzeImage() async {
    // Show a SnackBar if no image has been selected yet
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please capture a label first.")),
      );
      return; // Stop execution if no image
    }

    // Set loading state to true to show indicator and disable button
    setState(() {
      _isLoading = true;
    });

    try {
      // IMPORTANT: Replace "192.168.0.105" with your computer's actual local IP address.
      // If using Android emulator, "10.0.2.2" often points to your localhost.
      final uri = Uri.parse("http://192.168.0.105:5000/analyze");

      // Create a multipart request to send the image and other form data
      final request = http.MultipartRequest("POST", uri)
        // Use the userAllergies received from the widget
        ..fields['allergies'] = widget.userAllergies.join(',')
        ..files.add(
          await http.MultipartFile.fromPath('image', _image!.path),
        ); // Add the image file

      // Send the request and get the streamed response
      final streamedResponse = await request.send();
      // Convert the response stream to a string
      final responseBody = await streamedResponse.stream.bytesToString();

      // Check the HTTP status code
      if (streamedResponse.statusCode == 200) {
        // Ensure the widget is still mounted before navigating
        if (!mounted) return;
        // Navigate to the ResultScreen, passing the raw response body
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: responseBody),
          ),
        );
      } else {
        // If status code is not 200, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ Server Error: ${streamedResponse.statusCode}\n${responseBody}",
            ),
          ),
        );
      }
    } catch (e) {
      // Catch any network or other exceptions
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ An error occurred: $e")));
    } finally {
      // Always reset loading state when the operation completes or fails
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Product Label")),
      body: Center(
        child: SingleChildScrollView(
          // Allows the content to scroll if it overflows
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the captured image or a placeholder text
              if (_image != null)
                Container(
                  width: double.infinity, // Take full width
                  height: 250, // Fixed height for image preview
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover, // Cover the box, cropping if necessary
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "No image selected",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 30), // Spacing
              // Button to capture a new label
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _pickImage, // Disable while loading
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture Label"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15), // Spacing
              // Button to analyze allergens
              ElevatedButton(
                // Disable if no image is picked or if currently loading
                onPressed: _image == null || _isLoading ? null : _analyzeImage,
                child: _isLoading
                    ? const SizedBox(
                        // Show a small circular progress indicator
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text("Analyze Allergens"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: _image == null || _isLoading
                      ? Colors.grey
                      : Colors.green, // Change color when disabled
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
