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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appAppearanceViewModel.isDarkMode
            ? Colors.black
            : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appAppearanceViewModel.isDarkMode
              ? Colors.white
              : Colors.black,
        ),
        title: Text(
          'Change Email',
          style: TextStyle(
            color: appAppearanceViewModel.isDarkMode
                ? Colors.white
                : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: appAppearanceViewModel.isDarkMode
          ? Colors.black
          : Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildLabel('Old Email', appAppearanceViewModel.isDarkMode),
            buildInputField(
              controller: viewModel.oldEmailController,
              hint: 'Enter your old email',
              isDarkModeValue: appAppearanceViewModel.isDarkMode,
            ),
            const SizedBox(height: 20),
            buildLabel('New Email', appAppearanceViewModel.isDarkMode),
            buildInputField(
              controller: viewModel.newEmailController,
              hint: 'Enter your new email',
              isDarkModeValue: appAppearanceViewModel.isDarkMode,
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 265,
                height: 53,
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
                  onPressed: viewModel.isLoading
                      ? null
                      : () => viewModel.changeEmail(context, userId),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    'Change Email',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                           Colors.white
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
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor:
        isDarkModeValue ? Colors.grey[800] : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
