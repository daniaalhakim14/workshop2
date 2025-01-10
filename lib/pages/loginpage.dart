import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workshop2/pages/signuppage.dart';
import 'dart:convert';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false; // Password visibility toggle
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://10.131.74.186:3000/admin/login'), // Ensure this URL is correct
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          // Print login success message
          debugPrint('Login successful: ${responseData['user']}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } catch (e) {
          // Handle JSON decoding error
          debugPrint('Error decoding JSON: $e');
          debugPrint('Response body: ${response.body}');
        }
      } else {
        // Handle non-200 status codes
        debugPrint('Login failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle network or other errors
      debugPrint('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE665ADAD), // Background color using hex code
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hello Again!",
                  style: TextStyle(
                    fontSize: 42, // Text size
                    fontWeight: FontWeight.bold, // Bold text
                    color: Color(0xFF002B36), // Text color using hex code
                  ),
                ),
                const SizedBox(height: 20), // Spacing between the image and the text
                Text(
                  "Welcome Back! You've been missed",
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
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacing between text fields

                // Password TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey, // Eye icon color
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle state
                          });
                        },
                      ),
                    ),
                  ),
                ),
                //const SizedBox(height: 5), // Spacing after password field

                // Recovery Password Text
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Add recovery password action here
                      },
                      child: Text(
                        "Recovery Password", //forget password
                        style: TextStyle(
                          color: Colors.white, // Text color for recovery link
                          fontSize: 16, // Text size
                          fontWeight: FontWeight.bold, // Text weight
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Spacing after recovery text

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login, // Call the login function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF002B36),
                        foregroundColor: Colors.white,// Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15), // Button padding
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18, // Text size
                          fontWeight: FontWeight.bold, // Text weight
                        ),
                      ),
                    ),
                  ),
                ),

                /*const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white)), // Left divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white)), // Right divider
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //Icon Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/icons/google.png',
                            width: 30,  // Width of the image
                            height: 30,
                          ), // Replace with your image asset
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('assets/icons/apple.png',
                            width: 30,  // Width of the image
                            height: 30,), // Replace with your image asset
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('assets/icons/facebook.png',
                            width: 30,  // Width of the image
                            height: 30,), // Replace with your image asset
                        ),
                      ],
                    )
                  ],
                ),*/

                //const SizedBox(height: 100),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("not a member?", style: TextStyle(color: Colors.white),),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            color: Color(0xFF00BFFF), // Custom bright blue color
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF87CEFA), // Custom bright blue accent for underline
                          ),
                        ),
                      ),
                    ],
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