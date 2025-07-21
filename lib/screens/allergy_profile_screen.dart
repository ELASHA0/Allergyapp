import 'package:flutter/material.dart';
import 'package:allergyapp/screens/scan_screen.dart';

class AllergyProfileScreen extends StatefulWidget {
  const AllergyProfileScreen({super.key});

  @override
  State<AllergyProfileScreen> createState() => _AllergyProfileScreenState();
}

class _AllergyProfileScreenState extends State<AllergyProfileScreen> {
  final List<String> _userAllergies = [];
  final TextEditingController _allergyController = TextEditingController();

  // Define your consistent color palette based on "Tides" scheme
  static const Color backgroundColor = Color(
    0xFFE9EBED,
  ); // Lightest color from Tides
  static const Color primaryAccent = Color(
    0xFF006F98,
  ); // Darkest blue from Tides
  static const Color secondaryAccent = Color(0xFF1ABBEF); // Mid-blue from Tides
  static const Color lightBlue = Color(0xFF7FD2FD); // Light blue from Tides
  static const Color textColor = Color(
    0xFF003049,
  ); // A darker, complementary blue/navy for text
  static const Color lightTextColor =
      Colors.white; // Pure white for text on primary accent background

  void _addAllergy() {
    final newAllergy = _allergyController.text.trim();
    if (newAllergy.isNotEmpty && !_userAllergies.contains(newAllergy)) {
      setState(() {
        _userAllergies.add(newAllergy);
      });
      _allergyController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newAllergy.isEmpty
                ? 'Please enter an allergy.'
                : 'Allergy already exists.',
          ),
          backgroundColor: primaryAccent, // Use a color from your palette
        ),
      );
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
      backgroundColor: backgroundColor, // Apply the new background color
      appBar: AppBar(
        backgroundColor: primaryAccent, // Use primaryAccent for AppBar
        title: const Text(
          'My Allergy Profile',
          style: TextStyle(
            color: lightTextColor, // White title for better contrast
            fontWeight: FontWeight.bold, // Make the title stand out
            letterSpacing: 0.8, // Add a little spacing for a cleaner look
          ),
        ),
        centerTitle: true,
        elevation: 8.0, // Slightly increased elevation for more depth
        shadowColor: textColor.withOpacity(
          0.6,
        ), // Increased opacity for a more pronounced shadow
        shape: const RoundedRectangleBorder(
          // Add rounded corners to the bottom for a modern touch
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // Adjust the radius as desired
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ), // Add some padding to the right of the icon
            child: IconButton(
              icon: const Icon(
                Icons.qr_code_scanner,
                color: lightBlue, // Use lightBlue for icon
                size: 28.0,
              ), // Slightly larger icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ScanScreen(userAllergies: _userAllergies),
                  ),
                );
                // print('QR code scanner pressed');
              },
              tooltip:
                  'Scan QR Code', // Add a tooltip for accessibility and user guidance
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              20.0,
              16.0,
              16.0,
            ), // More top padding for breathing room
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _allergyController,
                    decoration: InputDecoration(
                      labelText: 'Add New Allergy',
                      labelStyle: TextStyle(
                        color: textColor.withOpacity(0.7), // Softer label color
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'e.g., Peanuts, Gluten', // Helpful hint text
                      hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                      filled: true,
                      fillColor:
                          Colors.white, // White background for the text field
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // More rounded corners
                        borderSide: BorderSide(
                          color: primaryAccent.withOpacity(
                            0.5,
                          ), // Subtle accent border
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color:
                              primaryAccent, // Stronger accent border when focused
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        // Define error border for validation
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        // Define focused error border
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 2.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, // Increased horizontal padding
                        vertical: 16, // Increased vertical padding
                      ),
                      suffixIcon: IconButton(
                        // Clear button for the text field
                        icon: Icon(
                          Icons.clear,
                          color: textColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          _allergyController.clear();
                        },
                      ),
                    ),
                    cursorColor: primaryAccent, // Accent color for the cursor
                    style: const TextStyle(
                      color: textColor, // Dark text color
                      fontSize: 16,
                    ),
                    textCapitalization: TextCapitalization
                        .words, // Capitalize words for allergies
                    keyboardType: TextInputType.text,
                    textInputAction:
                        TextInputAction.done, // 'Done' button on keyboard
                    onSubmitted: (_) => _addAllergy(),
                  ),
                ),
                const SizedBox(width: 12), // Slightly more spacing
                // --- Add Button ---
                ElevatedButton(
                  onPressed: _addAllergy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent, // Primary accent blue
                    foregroundColor: lightTextColor, // White for text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Match TextField roundedness
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24, // Generous horizontal padding
                      vertical: 16, // Match TextField height
                    ),
                    elevation: 4, // Subtle shadow for the button
                    shadowColor: textColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.add_rounded, // Use a rounded add icon for consistency
                    size: 26, // Slightly larger icon
                  ),
                ),
              ],
            ),
          ),
          // --- Divider for visual separation ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Divider(
              color:
                  secondaryAccent, // Use secondary accent color for the divider
              thickness: 1.5,
              height: 20,
            ),
          ),
          // --- Allergy List Section ---
          Expanded(
            child: _userAllergies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons
                              .warning_amber_rounded, // A more engaging empty state icon
                          size: 60,
                          color: primaryAccent.withOpacity(0.6),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'No allergies added yet!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your allergies above to get started.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ), // Padding for the entire list
                    itemCount: _userAllergies.length,
                    itemBuilder: (context, index) {
                      final allergy = _userAllergies[index];
                      return Dismissible(
                        // Enable swipe-to-delete with animation
                        key: Key(allergy), // Unique key for each item
                        direction: DismissDirection
                            .endToStart, // Only swipe from right to left
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color:
                              Colors.redAccent, // Red background when swiping
                          child: const Icon(
                            Icons.delete_sweep_rounded, // Animated delete icon
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (direction) {
                          // Show a SnackBar to confirm deletion and offer undo
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"$allergy" removed'),
                              backgroundColor:
                                  textColor, // Use darker text color for SnackBar
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor:
                                    lightBlue, // Use lightBlue for UNDO text
                                onPressed: () {
                                  // Re-insert the allergy if undo is pressed
                                  setState(() {
                                    _userAllergies.insert(index, allergy);
                                  });
                                },
                              ),
                            ),
                          );
                          _removeAllergy(
                            allergy,
                          ); // Call your existing remove logic
                        },
                        child: Card(
                          color:
                              secondaryAccent, // Use secondaryAccent for allergy items
                          margin: const EdgeInsets.symmetric(
                            horizontal:
                                8, // Adjust horizontal margin for consistency
                            vertical: 6, // More vertical spacing between cards
                          ),
                          elevation: 5, // Increased elevation for better depth
                          shadowColor: textColor.withOpacity(
                            0.3,
                          ), // Subtle shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ), // Match roundedness
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical:
                                  8, // More vertical padding inside ListTile
                            ),
                            title: Text(
                              allergy,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600, // Slightly bolder title
                                fontSize:
                                    18, // Larger font size for readability
                                color: lightTextColor, // White text for items
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons
                                    .close_rounded, // Use a clear "X" icon for removal
                                color: lightBlue, // Use lightBlue for the icon
                                size: 28, // Larger icon for easier tapping
                              ),
                              onPressed: () => _removeAllergy(allergy),
                              tooltip:
                                  'Remove Allergy', // Accessibility tooltip
                            ),
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
