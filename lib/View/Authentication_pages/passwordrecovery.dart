import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Passwordrecovery extends StatefulWidget {
  const Passwordrecovery({super.key});

  @override
  State<Passwordrecovery> createState() => _PasswordrecoveryState();
}

class _PasswordrecoveryState extends State<Passwordrecovery> {
  bool _isEmailVisible = false; // Email visibility toggle
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage; // To show error message for email validation

  Future<void> _passrecovery() async {
    final String email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _errorMessage = "Please enter an email address."; // Show error if email is empty
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.90:3000/admin/password-recovery'), // Updated endpoint for password recovery
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check the response data for email existence or validity
        if (responseData['status'] == 'success') {
          // Assuming the response contains a success status if the email exists
          debugPrint('Email found: ${responseData['message']}');
          setState(() {
            _errorMessage = 'A password reset link has been sent to your email.';
          });
        } else {
          // Handle email not found
          setState(() {
            _errorMessage = responseData['message'] ?? 'Email not found.';
          });
        }
      } else {
        // Handle non-200 status codes
        debugPrint('Error: ${response.statusCode}');
        setState(() {
          _errorMessage = 'An error occurred while processing your request.';
        });
      }
    } catch (e) {
      // Handle network or other errors
      debugPrint('Network error: $e');
      setState(() {
        _errorMessage = 'Unable to connect to the server. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE665ADAD), // Background color using hex code
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Stack(
              children: [
                // Main Column with Text and Fields
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Password Recovery",
                      style: TextStyle(
                        fontSize: 42, // Text size
                        fontWeight: FontWeight.bold, // Bold text
                        color: Color(0xFF002B36), // Text color using hex code
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing between the image and the text
                    Text(
                      "Please enter your email to reset the password ",
                      style: TextStyle(
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.w500, // Medium-weight text
                        color: Color(0xFFE0E0E0), // Text color using hex code
                      ),
                    ),
                    const SizedBox(height: 40), // Spacing before text fields
                    // Email/Username TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        controller: _emailController,
                        obscureText: !_isEmailVisible,
                        decoration: InputDecoration(
                          labelText: "Enter Your Email",
                          labelStyle: TextStyle(color: Colors.grey), // Label text color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded borders
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isEmailVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey, // Eye icon color
                            ),
                            onPressed: () {
                              setState(() {
                                _isEmailVisible = !_isEmailVisible; // Toggle state
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing between text fields
                    // Error Message Display
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red, // Error message color
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20), // Spacing before the button
                    // Reset Password Button
                    SizedBox(
                      width: 300, // Fixed width for both buttons
                      child: ElevatedButton(
                        onPressed: _passrecovery,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal, // Button background color
                          shape: RoundedRectangleBorder( // Shape
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                        ),
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 18, // Text size
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Arrow Icon on the top left
                Positioned(
                  top: 5, // Position from top
                  left: 20, // Position from left
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: Color(0xFF002B36), // Color for the arrow icon
                    onPressed: () {
                      Navigator.pop(context); // Action when the icon is tapped
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
