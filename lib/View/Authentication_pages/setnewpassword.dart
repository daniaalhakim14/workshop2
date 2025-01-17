import 'package:flutter/material.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE665ADAD), // Background color using hex code
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Set a new Password",
                    style: TextStyle(
                      fontSize: 42, // Text size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Color(0xFF002B36), // Text color using hex code
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create a new password. Ensure it differs from the previous password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Text size
                      fontWeight: FontWeight.w500, // Medium-weight text
                      color: Color(0xFFE0E0E0), // Text color using hex code
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter New Password",
                      labelStyle: const TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm New Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Confirm New Password",
                      labelStyle: const TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 300, // Fixed width for button
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal, // Button background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15), // Adjusted vertical padding
                        ),
                        child: const Text(
                          "Update Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20, // Position from top
              left: 10, // Position from left
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 30,
                color: const Color(0xFF002B36), // Color for the arrow icon
                onPressed: () {
                  Navigator.pop(context); // Action when the icon is tapped
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
