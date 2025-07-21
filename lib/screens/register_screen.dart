import 'package:allergyapp/models/auth_service.dart';
import 'package:allergyapp/screens/allergy_profile_screen.dart';
import 'package:allergyapp/screens/main_navigation.dart';
import 'package:allergyapp/screens/onboarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// No need to import home_screen.dart if only navigating to OnboardingScreen or popping
// import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Define your consistent color palette based on "Tides" scheme
  static const Color backgroundColor = Color(
    0xFFE9EBED,
  ); // Lightest color from Tides
  static const Color primaryAccent = Color(
    0xFF006F98,
  ); // Darkest blue from Tides
  static const Color secondaryAccent = Color(0xFF1ABBEF); // Mid-blue from Tides
  static const Color textColor = Color(
    0xFF003049,
  ); // A darker, complementary blue/navy for text
  static const Color lightTextColor =
      Colors.white; // Pure white for text on primary accent background

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters long.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear previous errors
    });

    try {
      final User? user = await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        // If registration is successful, navigate to OnboardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        // This 'else' might not be hit if FirebaseAuthException catches all issues.
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            _errorMessage =
                'The password provided is too weak. Please use a stronger one.';
            break;
          case 'email-already-in-use':
            _errorMessage = 'An account already exists for this email address.';
            break;
          case 'invalid-email':
            _errorMessage = 'The email address is not valid.';
            break;
          case 'network-request-failed':
            _errorMessage =
                'Network error. Please check your internet connection.';
            break;
          default:
            _errorMessage =
                'Registration failed: ${e.message ?? 'An unknown error occurred.'}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Apply the new background color
      body: SafeArea(
        // Use SafeArea to avoid content overlapping status bar
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 30.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Back Button (Optional, if you want a custom one instead of default AppBar back button)
                // Space after back button
                // Illustration/Logo

                // Title Text
                Text(
                  "Create Your Account",
                  style: TextStyle(
                    color: textColor, // Use darker blue for title
                    fontWeight: FontWeight.bold,
                    fontSize: 28, // Larger and more prominent
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),

                // Error Message Display
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Name TextField
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    filled: true,
                    fillColor: lightTextColor, // White fill for contrast
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: primaryAccent,
                        width: 2,
                      ), // Accent border on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ), // Light border when enabled
                    ),
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: primaryAccent.withOpacity(
                        0.8,
                      ), // Accent color for icon
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 15.0,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: textColor),
                ),
                const SizedBox(height: 20),

                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    filled: true,
                    fillColor: lightTextColor, // White fill for contrast
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: primaryAccent,
                        width: 2,
                      ), // Accent border on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ), // Light border when enabled
                    ),
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: primaryAccent.withOpacity(
                        0.8,
                      ), // Accent color for icon
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 15.0,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: textColor),
                ),
                const SizedBox(height: 20),

                // Password TextField
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    filled: true,
                    fillColor: lightTextColor, // White fill for contrast
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: primaryAccent,
                        width: 2,
                      ), // Accent border on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ), // Light border when enabled
                    ),
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: primaryAccent.withOpacity(
                        0.8,
                      ), // Accent color for icon
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 15.0,
                    ),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: textColor),
                ),
                const SizedBox(height: 30),

                // Register Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: lightTextColor, // Text color is white
                    backgroundColor: _isLoading
                        ? Colors.grey.shade400
                        : primaryAccent, // Dark blue background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 18,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8, // Pronounced shadow for a "lifted" effect
                    shadowColor: textColor.withOpacity(0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text("Register"),
                ),
                const SizedBox(height: 20),

                // Already have account? Login button
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context), // Go back to login screen
                  style: TextButton.styleFrom(
                    foregroundColor:
                        secondaryAccent, // Mid-blue color for TextButton
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Already have an account? Login here!'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
