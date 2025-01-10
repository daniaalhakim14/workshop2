import 'package:flutter/material.dart';
import 'loginpage.dart'; // Import the LoginPage
import 'signuppage.dart'; // Import the SignupPage

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
              'assets/images/appfirstpage.png', // Replace with your image path
              width: 300, // Adjust the size
              height: 300, // Adjust the size
              fit: BoxFit.contain, // Adjust the fit
            ),
            const SizedBox(height: 20), // Spacing between the image and the text
            Text(
              "My Duit",
              style: TextStyle(
                fontSize: 42, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Color(0xFF002B36), // Text color using hex code
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "One step closer to smarter money management, every day",
              style: TextStyle(
                fontSize: 13.5, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // Text color
              ),
            ),
            const SizedBox(height: 50),
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
