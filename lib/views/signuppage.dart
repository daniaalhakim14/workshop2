import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_viewmodel.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xE665ADAD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002B36),
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildInputField("Full Name", viewModel.nameController),
            buildInputField("Email Address", viewModel.emailController),
            buildInputField("Phone Number", viewModel.phoneController),
            buildPasswordField(viewModel, "Password", viewModel.passwordController),
            buildPasswordField(viewModel, "Confirm Password", viewModel.confirmPasswordController),
            buildInputField("Address", viewModel.addressController, maxLines: 3),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () => viewModel.signup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002B36),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPasswordField(SignupViewModel viewModel, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: !viewModel.isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(
              viewModel.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              viewModel.isPasswordVisible = !viewModel.isPasswordVisible;
              viewModel.notifyListeners();
            },
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
