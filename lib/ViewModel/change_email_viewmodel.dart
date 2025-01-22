import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../configure_API.dart';

class ChangeEmailViewModel extends ChangeNotifier {
  final TextEditingController oldEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  bool isLoading = false;

  Future<void> changeEmail(BuildContext context, int userId) async {
    final oldEmail = oldEmailController.text.trim();
    final newEmail = newEmailController.text.trim();

    if (oldEmail.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/changeEmail/change-email'),
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

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmail', newEmail);

        oldEmailController.clear();
        newEmailController.clear();

        Navigator.pop(context);
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Old email is incorrect')),
        );
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New email is already in use')),
        );
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'An error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
