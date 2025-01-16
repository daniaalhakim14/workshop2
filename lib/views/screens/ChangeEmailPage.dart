import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_appearance_viewmodel.dart';
import '../../viewmodels/change_email_viewmodel.dart';

class ChangeEmailPage extends StatelessWidget {
  final int userId;

  const ChangeEmailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChangeEmailViewModel>(context);
    final appAppearanceViewModel = Provider.of<AppAppearanceViewModel>(context);
    final isDarkModeValue = appAppearanceViewModel.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkModeValue ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkModeValue ? Colors.white : Colors.black,
        ),
        title: Text(
          'Change Email',
          style: TextStyle(
            color: isDarkModeValue ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkModeValue ? Colors.white : Colors.black,
          ),
          onPressed: () {
            viewModel.oldEmailController.clear();
            viewModel.newEmailController.clear();
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: isDarkModeValue ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel('Old Email', isDarkModeValue),
            const SizedBox(height: 10),
            buildInputField(
              controller: viewModel.oldEmailController,
              hint: 'Enter your old email',
              isDarkModeValue: isDarkModeValue,
            ),
            const SizedBox(height: 20),
            buildLabel('New Email', isDarkModeValue),
            const SizedBox(height: 10),
            buildInputField(
              controller: viewModel.newEmailController,
              hint: 'name@example.com',
              isDarkModeValue: isDarkModeValue,
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: viewModel.isLoading
                      ? null
                      : () {
                    FocusScope.of(context).unfocus();
                    viewModel.changeEmail(context, userId);
                  },
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text(
                    'Change Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text, bool isDarkModeValue) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDarkModeValue ? Colors.white : Colors.black,
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required bool isDarkModeValue,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor:
        isDarkModeValue ? Colors.grey[800] : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: isDarkModeValue ? Colors.white54 : Colors.black54,
        ),
      ),
      style: TextStyle(
        color: isDarkModeValue ? Colors.white : Colors.black,
      ),
    );
  }
}

