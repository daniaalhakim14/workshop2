import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/SignupLoginPage_ViewModel/SignupLoginPage_View_Model.dart';
import 'loginpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  Future<void> _signup() async {
    final viewModel = Provider.of<SignupLoginPage_ViewModule>(context, listen: false);

    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;
    final String repeatPassword = _repeatPasswordController.text;
    final String unit = _unitController.text;
    final String city = _cityController.text;
    final String state = _stateController.text;
    final String postcode = _postcodeController.text;

    final String address = "$unit, $city, $postcode, $state";

    final success = await viewModel.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
      repeatPassword: repeatPassword,
      address: address,
    );

    if (success) {
      // Navigate to login page on successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // Display errors if validation fails
      setState(() {}); // Refresh UI to show validation errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up failed. Please check the errors and try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupLoginPage_ViewModule>(context);

    return Scaffold(
      backgroundColor: const Color(0xE665ADAD),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002B36),
                  ),
                ),
                const Text(
                  "Ready to take control? Take the first step",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                const Text(
                  "Sign up now and start your journey!",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                _buildSectionLabel("Full Name"),
                _buildTextField("Full Name", "Enter Name", _nameController, viewModel.nameError),
                _buildSectionLabel("Email Address"),
                _buildTextField("Email Address", "name@example.com", _emailController, viewModel.emailError),
                _buildSectionLabel("Phone Number"),
                _buildTextField("Phone Number", "(+xx) xx-xxx xxxx", _phoneController, viewModel.phoneError),
                _buildSectionLabel("Password"),
                _buildPasswordField("Password", "Enter Password", _passwordController, viewModel.passwordError),
                _buildSectionLabel("Repeat Password"),
                _buildPasswordField("Repeat Password", "Enter Repeat Password", _repeatPasswordController, viewModel.repeatPasswordError),
                _buildSectionLabel("House No., Building, Street Name"),
                _buildTextField("House No., Building, Street Name", "No.1234 Jalan 2, Taman", _unitController, viewModel.addressError),
                _buildSectionLabel("City"),
                _buildTextField("City", "City", _cityController, null),
                _buildSectionLabel("State"),
                _buildTextField("State", "State", _stateController, null),
                _buildSectionLabel("Postcode"),
                _buildTextField("Postcode", "XXXXX", _postcodeController, null),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002B36),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5), // Thicker border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.grey), // Thicker border for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.blue), // Thicker border for focused state
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.red), // Thicker border for error state
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.red), // Thicker border for focused error state
          ),
          filled: true,
          fillColor: Colors.white,
          errorText: errorText,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold, // Make the error message bold
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5), // Thicker border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.grey), // Thicker border for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.blue), // Thicker border for focused state
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.red), // Thicker border for error state
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2.5, color: Colors.red), // Thicker border for focused error state
          ),
          filled: true,
          fillColor: Colors.white,
          errorText: errorText,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold, // Make the error message bold
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
