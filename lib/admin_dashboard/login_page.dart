import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http; // Import HTTP package for API requests
import 'package:get/get.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for Email and Password input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to handle login
  Future<void> _login() async {
 
    String testEmail = 'admin@gmail.com';
    String testPassword = 'a123';

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all fields')),
    );
    return;
    }
    if (_emailController.text == testEmail && _passwordController.text == testPassword) {
    // Navigate to home page
    Get.offAllNamed(postPageRoute);
  } else {
    // Show error message for invalid credentials
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid credentials, please try again')),
    );
  }
    /*        
    // API endpoint URL
    final url = 'http://your-backend-api-url/login'; 

    // Prepare data to send
    final body = json.encode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });
    // Making a POST request to the backend API  
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );    
    // Checking the response
    if (response.statusCode == 200) {
      // If the login is successful, navigate to the next page
      Navigator.pushNamed(context, '/nextPage'); // Adjust the route to your next page
    } else {
      // Handle errors (e.g., invalid credentials)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials, please try again')),
      );
    }
    */




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF65ADAD),
      body: Row(
        children: [
          
          // Left Part: Icon + Name

          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("lib/Icons/financial_app.png", width: 500, height: 500),
                  SizedBox(height: 20),
                  Text(
                    'AI Finance Advisor',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF002B36),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              child:  Padding(
                padding: const EdgeInsets.all(100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello Again!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF002B36),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Welcome back! You\'ve been missed',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _emailController, // Use controller to manage input
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController, // Use controller to manage input
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: (){
                        _login();
                      },child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF002B36),
                            ),
                            onPressed: _login, // Call login function
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
           
          ),
        ],
      ),
    );
  }
}
