import 'package:allergyapp/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Use the new background color
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 3;
                  });
                },
                children: List.generate(4, (index) => buildPage(index)),
              ),
            ),

            /// Dot Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: const WormEffect(
                activeDotColor:
                    primaryAccent, // Use primary accent for active dot
                dotColor: lightBlue, // Use light blue for inactive dots
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),

            const SizedBox(height: 30),

            /// Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigationScreen(),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        primaryAccent, // Button color is primary accent
                    foregroundColor: lightTextColor, // Text color is white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isLastPage ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildPage(int index) {
    final titles = [
      "Select Your Allergens",
      "Scan Products Easily",
      "Get Instant Results",
      "Stay Safe Always",
    ];
    final subtitles = [
      "Tell us what you're allergic to so we can keep you safe.",
      "Scan any food product label to detect allergens.",
      "We’ll instantly notify if allergens are found.",
      "Your health is our priority — always stay informed.",
    ];
    final images = [
      'assets/images/undraw_cookie-love_t5px.png',
      'assets/images/undraw_diet_zdwe.png',
      'assets/images/undraw_hamburger_falh.png',
      'assets/images/undraw_ice-cream_mhwt.png', // Corrected path
    ];
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          flex: 5,
          child: Center(
            child: Image.asset(
              'assets/${images[index]}', // Ensure 'assets/' prefix is correct
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                titles[index],
                style: const TextStyle(
                  fontSize: 26, // Slightly larger title for impact
                  fontWeight: FontWeight.bold,
                  color: textColor, // Use the new text color
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  subtitles[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ), // Softer text color
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
