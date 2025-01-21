import 'package:flutter/material.dart';
import 'package:tab_bar_widget/View/Main_pages/signupage.dart';
import 'package:tab_bar_widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ViewModel/SignupLoginPage_ViewModel/SignupLoginPage_View_Model.dart';
import 'loginpage.dart';
import 'homepage.dart'; // Import HomePage class
import 'signupage.dart'; // Import SignupPage class

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  // Check login state from SharedPreferences
  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final viewModel = Provider.of<SignupLoginPage_ViewModule>(
          context, listen: false);
      final String email = prefs.getString('userEmail') ?? '';
      final String password = prefs.getString('userPassword') ?? '';

      final success = await viewModel.login(email, password,context);

      if (success) {
        await viewModel.fetchUserDetailsByEmail(email);
        if (viewModel.userInfo != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userInfo: viewModel.userInfo!),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to fetch user details."),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE665ADAD), // Background color using hex code
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/Icons/appfirstpage.png', // Replace with your image path
              width: 230,
              height: 230,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            const Text(
              "MyDuit",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "One step closer to smarter \nmoney management, every day",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Login Button
            SizedBox(
              width: 300, // Fixed width for both buttons
              child: ElevatedButton(
                onPressed: () {
                  _navigateWithLoading(const LoginPage()); // Navigate with loading to SignupPage
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Sign Up Button
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  _navigateWithLoading(const SignupPage()); // Navigate with loading to SignupPage
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

  void _navigateWithLoading(Widget page) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (context) => const LoadingPage(),
    );

    // Wait for 3 seconds, then navigate to the desired page
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Close the loading dialog
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    });
  }


}