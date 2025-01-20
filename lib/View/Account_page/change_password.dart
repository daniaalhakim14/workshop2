import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/app_appearance_viewmodel.dart';
import '../../ViewModel/change_password_viewmodel.dart';



class ChangePassword extends StatefulWidget {
  final int userId;

  const ChangePassword({super.key, required this.userId});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAppearanceViewModel>(
      builder: (context, appAppearanceViewModel, child) {
        final isDarkModeValue = appAppearanceViewModel.isDarkMode;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkModeValue ? Colors.black : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkModeValue ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                color: isDarkModeValue ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: isDarkModeValue ? Colors.black : Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<ChangePasswordViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPasswordField(
                      'Current Password',
                      currentPasswordController,
                      isDarkModeValue,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      'New Password',
                      newPasswordController,
                      isDarkModeValue,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      'Confirm New Password',
                      confirmPasswordController,
                      isDarkModeValue,
                    ),
                    const SizedBox(height: 30),
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final currentPassword = currentPasswordController.text.trim();
                        final newPassword = newPasswordController.text.trim();
                        final confirmPassword = confirmPasswordController.text.trim();

                        if (currentPassword.isEmpty ||
                            newPassword.isEmpty ||
                            confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All fields are required')),
                          );
                        } else if (newPassword != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                        } else {
                          viewModel.changePassword(
                            context,
                            widget.userId,
                            currentPassword,
                            newPassword,
                          );
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      bool isDarkModeValue,
      ) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(
        color: isDarkModeValue ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkModeValue ? Colors.white : Colors.black54,
        ),
        filled: true,
        fillColor: isDarkModeValue ? Colors.grey[800] : const Color(0xFFD9D9D9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
