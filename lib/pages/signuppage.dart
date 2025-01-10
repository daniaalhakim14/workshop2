import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workshop2/pages/homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isPasswordVisible = false; // Password visibility toggle
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _repeatPasswordError;
  String? _unitError;
  String? _cityError;
  String? _stateError;
  String? _postcodeError;
  String address = "";

  Future<void> _signup() async {
    setState(() {
      // Reset error messages before validation
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _repeatPasswordError = null;
      _unitError = null;
      _cityError = null;
      _stateError = null;
      _postcodeError = null;
    });

    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String repeatPassword = _repeatPasswordController.text;
    final String unit = _unitController.text;
    final String city = _cityController.text;
    final String state = _stateController.text;
    final String postcode = _postcodeController.text;

    // Validate name
    if (name.isEmpty && name.length < 3) {
      setState(() {
        _nameError = 'Name cannot be empty and at least 3 character';
      });
      return;
    }

    // Validate email
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email cannot be empty';
      });
      return;
    } else if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      setState(() {
        _emailError = 'Enter a valid email';
      });
      return;
    }

    // Validate phone number
    if (phone.isEmpty) {
      setState(() {
        _phoneError = 'Phone number cannot be empty';
      });
      return;
    } else if (!RegExp(r"^\+?[0-9]{1,4}?[0-9]{7,15}$").hasMatch(phone)) {
      setState(() {
        _phoneError = 'Enter a valid phone number';
      });
      return;
    }

    // Validate password
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
      });
      return;
    } else if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      return;
    }

    // Validate repeat password
    if (repeatPassword.isEmpty) {
      setState(() {
        _repeatPasswordError = 'Please confirm your password';
      });
      return;
    } else if (password != repeatPassword) {
      setState(() {
        _repeatPasswordError = 'Passwords do not match';
      });
      return;
    }

    // Validate unit
    if (unit.isEmpty) {
      setState(() {
        _unitError = 'House No., Building, Street Name cannot be empty';
      });
      return;
    }

    // Validate city
    if (city.isEmpty) {
      setState(() {
        _unitError = 'City cannot be empty';
      });
      return;
    }

    // Validate state
    if (state.isEmpty) {
      setState(() {
        _unitError = 'State cannot be empty';
      });
      return;
    }

    // Validate postcode
    if (postcode.isEmpty) {
      setState(() {
        _unitError = 'Postcode cannot be empty';
      });
      return;
    }

    if (unit.isNotEmpty && city.isNotEmpty && state.isNotEmpty && postcode.isNotEmpty) {
      setState(() {
        address = "$unit, $city, $postcode, $state";
      });
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.131.74.186:3000/admin/signup'), // Ensure this URL is correct
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': email, // Assuming username is the email
          'password': password,
          'name': name,
          'email': email,
          'phonenumber': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 201) {
        // Sign-up successful
        final responseData = jsonDecode(response.body);
        debugPrint('Sign-up successful: ${responseData['user']}');
        // Navigate to another page or show success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Sign-up failed
        final responseData = jsonDecode(response.body);
        debugPrint('Sign-up failed: ${responseData['message']}');
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
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 42, // Text size
                    fontWeight: FontWeight.bold, // Bold text
                    color: Color(0xFF002B36), // Text color using hex code
                  ),
                ),
                Text(
                  "Ready to take control? Take the first step",
                  style: TextStyle(
                    fontSize: 17, // Text size
                    fontWeight: FontWeight.w500, // Medium-weight text
                    color: Color(0xFFE0E0E0), // Text color using hex code
                  ),
                ),
                Text(
                  "Sign up now and start your journey!",
                  style: TextStyle(
                    fontSize: 17, // Text size
                    fontWeight: FontWeight.w500, // Medium-weight text
                    color: Color(0xFFE0E0E0), // Text color using hex code
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 5, top: 5), // Adjusted bottom and added top padding
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Full Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Full name TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Enter Name",
                      hintText: "Enter your full name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _nameError,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ,top: 5), // Reduced top padding
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Email TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "name@example.com",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Enter Email",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ,top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Phone Number TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "(+xx) xx-xxx xxxx",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Enter Phone Number",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _phoneError,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ,top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Password TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _passwordError,
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
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password Strength",
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 10, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ,top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Repeat Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Password TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _repeatPasswordController,
                    obscureText: !_isPasswordVisible, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: "Enter Repeat Password",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _repeatPasswordError,
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
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ,top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "House No., Building, Street Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Address TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _unitController,
                    decoration: InputDecoration(
                      hintText: "No.1234 Jalan 2, Taman",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Enter House No., Building, Street Name",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _unitError,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "City",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Address TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: "City",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Enter City",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _cityError,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "State",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Address TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      hintText: "State",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Enter State",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _stateError,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 5 ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Postcode",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    ),
                  ),
                ),
                // Address TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _postcodeController,
                    decoration: InputDecoration(
                      hintText: "XXXXX",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Enter Postcode",
                      labelStyle: TextStyle(color: Colors.grey), // Label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _postcodeError,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: _signup, // Call the sign-up function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF002B36), // Button color
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18, // Text size
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Extra space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}