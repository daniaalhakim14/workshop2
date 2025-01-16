import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangeEmailViewModel extends ChangeNotifier {
  final TextEditingController oldEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  bool isLoading = false;

  Future<void> changeEmail(BuildContext context, int userId) async {
    final oldEmail = oldEmailController.text.trim();
    final newEmail = newEmailController.text.trim();


    if (oldEmail.isEmpty || newEmail.isEmpty) {
      _showError(context, 'Please fill in both fields');
      return;
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(oldEmail)) {
      _showError(context, 'Old email is not valid');
      return;
    }
    if (!emailRegex.hasMatch(newEmail)) {
      _showError(context, 'New email is not valid');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.20:3000/api/change-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'oldEmail': oldEmail,
          'newEmail': newEmail,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email updated successfully')),
        );

        oldEmailController.clear();
        newEmailController.clear();

        Navigator.pop(context);
      } else if (response.statusCode == 404) {
        _showError(context, 'Old email is incorrect');
      } else if (response.statusCode == 409) {
        _showError(context, 'New email is already in use');
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'An unknown error occurred';
        _showError(context, 'Error: $errorMessage');
      }
    } catch (e) {
      _showError(context, 'Error: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    oldEmailController.dispose();
    newEmailController.dispose();
    super.dispose();
  }
}

