import 'package:flutter/material.dart';
import 'package:tab_bar_widget/View/auth/signupage.dart';

import 'loginpage.dart';


class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE665ADAD), // Background color using hex code
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your image here
            Image.asset(
              'lib/Icons/appfirstpage.png', // Replace with your image path
              width: 230, // Adjust the size
              height: 230, // Adjust the size
              fit: BoxFit.contain, // Adjust the fit
            ),
            const SizedBox(height: 10), // Spacing between the image and the text
            const Text(
              "MyDuit",
              style: TextStyle(
                fontSize: 50, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // Text color using hex code
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "One step closer to smarter \nmoney management,every day",
                textAlign: TextAlign.center, // Ensures text is centered within the widget
                style: TextStyle(
                  fontSize: 13.5, // Text size
                  fontWeight: FontWeight.normal, // Bold text
                  color: Colors.white, // Text color
                ),
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: 300, // Fixed width for both buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal, // Button background color
                  shape: RoundedRectangleBorder( // Shape
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                ),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300, // Same fixed width for the second button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()), // Navigate to LoginPage
                  );
                  // Add navigation for sign-up here, if needed
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal, // Button background color
                  shape: RoundedRectangleBorder( // Shape
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                ),
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
