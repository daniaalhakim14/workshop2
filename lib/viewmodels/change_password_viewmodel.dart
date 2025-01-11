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
      ) async {
    final url = Uri.parse('http://192.168.0.6:3000/api/change-password');
    isLoading = true;
    notifyListeners();

    print('Attempting to change password...');
    print('API Request - UserID: $userId, Current Password: $currentPassword, New Password: $newPassword');

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

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid current password')),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
