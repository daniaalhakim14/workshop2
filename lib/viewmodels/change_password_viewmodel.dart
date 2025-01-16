import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<void> changePassword(
      BuildContext context,
      int userId,
      String currentPassword,
      String newPassword,
      String repeatPassword,
      ) async {
    if (currentPassword.isEmpty) {
      _showError(context, 'Current password cannot be empty');
      return;
    }

    if (newPassword.isEmpty) {
      _showError(context, 'New password cannot be empty');
      return;
    }

    if (newPassword.length < 6) {
      _showError(context, 'Password must be at least 6 characters long');
      return;
    }

    if (repeatPassword.isEmpty) {
      _showError(context, 'Please confirm your password');
      return;
    }

    if (newPassword != repeatPassword) {
      _showError(context, 'Passwords do not match');
      return;
    }

    final url = Uri.parse('http://192.168.0.20:3000/api/change-password');
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 404) {
        _showError(context, 'User not found');
      } else if (response.statusCode == 401) {
        _showError(context, 'Invalid current password');
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        _showError(context, 'Error: $error');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _showError(context, 'Error: ${e.toString()}');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

