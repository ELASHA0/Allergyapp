import 'package:allergyapp/models/auth_service.dart';
import 'package:allergyapp/screens/onboarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart'; // Ensure this is correctly imported if needed, though replaced by OnboardingScreen
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear previous errors
    });

    try {
      final User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        // If login is successful, navigate to OnboardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else {
        // This 'else' might not be hit if FirebaseAuthException catches all issues.
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            _errorMessage = 'Wrong password provided for that user.';
            break;
          case 'invalid-email':
            _errorMessage = 'The email address is not valid.';
            break;
          case 'user-disabled':
            _errorMessage = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            _errorMessage = 'Too many failed attempts. Please try again later.';
            break;
          case 'network-request-failed':
            _errorMessage =
                'Network error. Please check your internet connection.';
            break;
          default:
            _errorMessage =
                'Login failed: ${e.message ?? 'An unknown error occurred.'}';
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
            ), // Generous padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title Text
                Text(
                  "Welcome Back!", // More welcoming title
                  style: TextStyle(
                    color: textColor, // Use darker blue for body title
                    fontWeight: FontWeight.bold,
                    fontSize: 28, // Larger title to stand out
                    letterSpacing: 1.0, // Increased letter spacing for flair
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Illustration/Logo
                /*Image.asset(
                  'assets\images\WhatsApp Image 2025-07-19 at 11.43.47_f42b0d58.jpg', // Changed to the new image
                  height: 180, // Adjust size as needed
                ),*/
                const SizedBox(height: 30),

                // Error Message Display
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50, // Lighter red background
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
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
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Rounded corners
                      borderSide: BorderSide.none, // No border by default
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

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _handleLogin, // Use _handleLogin
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
                      borderRadius: BorderRadius.circular(
                        18,
                      ), // More rounded corners
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
                      : const Text("Login"),
                ),
                const SizedBox(height: 20),

                // Register Button
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  ),
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
                  child: const Text(
                    'Don\'t have an account? Register Now!',
                  ), // More engaging text
                ),
                const SizedBox(height: 10), // Space at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
