import 'dart:convert';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({super.key, required this.result});

  // Helper widget to build a styled section with a heading and content box
  Widget _buildInfoSection(
    String title,
    Widget content, {
    Color? headingBgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading Box
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color:
                  headingBgColor ??
                  Colors
                      .blueAccent
                      .shade100, // Default heading background color
              borderRadius: BorderRadius.circular(
                10,
              ), // Rounded corners for the heading
            ),
            width: double.infinity, // Make it span the full width
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87, // Darker text for contrast
              ),
            ),
          ),
          const SizedBox(height: 8), // Space between heading and content
          // Content Box
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors
                  .grey
                  .shade200, // Different background color for content
              borderRadius: BorderRadius.circular(
                10,
              ), // Rounded corners for content box
            ),
            width: double.infinity, // Make it span the full width
            child: content,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> parsedResult = {};
    try {
      // Attempt to decode the result string into a Map
      parsedResult = json.decode(result) as Map<String, dynamic>;
    } catch (e) {
      // If decoding fails, it means the result is not a valid JSON.
      // This typically happens if there was an error response from the server.
      return Scaffold(
        appBar: AppBar(title: const Text('Analysis Result')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                const Text(
                  "Failed to parse analysis result.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Raw response: $result", // Show the raw response for debugging
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Safely extract data from the parsed JSON with null checks
    // Provide default empty lists or strings if keys are missing
    List<dynamic> extractedIngredients =
        parsedResult['extracted_ingredients'] ?? [];
    List<dynamic> detectedAllergens = parsedResult['detected_allergens'] ?? [];
    String recommendation =
        parsedResult['recommendation'] ?? "No recommendation provided.";
    // Convert risk_level to lowercase for consistent comparison
    String riskLevel =
        parsedResult['risk_level']?.toString().toLowerCase() ?? "unknown";

    // Determine the color and display text for the risk level
    Color riskBgColor;
    Color riskTextColor;
    String riskDisplayText;

    switch (riskLevel) {
      case "high":
        riskBgColor = Colors.red.shade200; // Light red background
        riskTextColor = Colors.red.shade800; // Darker red text
        riskDisplayText = "HIGH"; // Bold and uppercase for emphasis
        break;
      case "moderate":
        riskBgColor = Colors.amber.shade200; // Light amber background
        riskTextColor = Colors.amber.shade800; // Darker amber text
        riskDisplayText = "MODERATE";
        break;
      case "low":
        riskBgColor = Colors.green.shade200; // Light green background
        riskTextColor = Colors.green.shade800; // Darker green text
        riskDisplayText = "LOW";
        break;
      default:
        riskBgColor = Colors.grey.shade200; // Default grey background
        riskTextColor = Colors.black; // Default black text
        riskDisplayText = "UNKNOWN";
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: SingleChildScrollView(
        // Use SingleChildScrollView for scrollability
        padding: const EdgeInsets.all(16.0), // Overall padding for the screen
        child: Column(
          mainAxisSize: MainAxisSize.min, // Added this line to help with layout
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: [
            // Risk Level Section
            _buildInfoSection(
              "Risk Level",
              Text(
                riskDisplayText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // Make it bold
                  color: riskTextColor, // Apply the determined text color
                ),
              ),
              headingBgColor:
                  riskBgColor, // Use the determined background color for the heading
            ),
            const SizedBox(height: 16), // Space between sections
            // Extracted Ingredients Section
            _buildInfoSection(
              "Extracted Ingredients",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: extractedIngredients.isEmpty
                    ? [const Text("No ingredients extracted.")]
                    : extractedIngredients
                          .map(
                            (ingredient) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text("- $ingredient"),
                            ),
                          )
                          .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Detected Allergens Section
            _buildInfoSection(
              "Detected Allergens",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: detectedAllergens.isEmpty
                    ? [const Text("No allergens detected.")]
                    : detectedAllergens
                          .map(
                            (allergen) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                "⚠️ $allergen", // Add a warning emoji
                                style: const TextStyle(
                                  color:
                                      Colors.red, // Highlight allergens in red
                                  fontWeight: FontWeight.bold, // Make them bold
                                ),
                              ),
                            ),
                          )
                          .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Recommendation Section
            _buildInfoSection(
              "Recommendation",
              Text(recommendation, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
