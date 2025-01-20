import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_model/login_vm.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = Get.put(LoginViewModel());

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
                    'My Duit',
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
          // Right Part: Login Form
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    // Email TextField
                    CustomTextField(
                      label: 'Enter Email',
                      controller: viewModel.emailController,
                      onChanged: (value) => viewModel.currentAdmin?.email = value,
                      isSecured: false,
                    ),
                    SizedBox(height: 20),
                    // Password TextField
                    CustomTextField(
                      label: 'Enter Password',
                      controller: viewModel.passwordController,
                      onChanged: (value) => viewModel.currentAdmin?.password = value,
                      isSecured: true,
                    ),
                    SizedBox(height: 40),
                    // Login Button
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF002B36),
                        ),
                        onPressed: () async {
                          await viewModel.loginAdmin();
                        },
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

// CustomTextField Widget
Widget CustomTextField({
  required String label,
  required TextEditingController controller,
  required Function(String) onChanged,
  required bool isSecured,
}) {
  return TextField(
    controller: controller,
    obscureText: isSecured,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
    ),
  );
}


/*import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http; // Import HTTP package for API requests
import 'package:get/get.dart';
import 'package:workshop_2/admin_dashboard/controllers/login_controller.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';


class LoginPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    CustomTextField(label: 'Enter Email' , txtController: controller.email,isSecured: false),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Enter Password' , txtController: controller.password,isSecured: true),
                    SizedBox(height: 40),
                    SizedBox(
                      width: 300, 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF002B36),
                        ),
                        onPressed: () async {
                          await controller.submit();
                        },
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


Widget CustomTextField( {required String label, required TextEditingController txtController,required bool isSecured}){
  return TextField(
    controller: txtController, // Use controller to manage input
    obscureText: isSecured,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
*/