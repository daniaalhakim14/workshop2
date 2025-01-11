import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<void> fetchUserDetails(int userId) async {
    if (userId <= 0) throw Exception('Invalid userId provided');

    _setLoading(true);

    try {
      final uri = Uri.parse('http://192.168.0.6:3000/api/user/$userId');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          nameController.text = data['user']['name'] ?? '';
          addressController.text = data['user']['address'] ?? '';
          phoneController.text = data['user']['phonenumber'] ?? '';
          emailController.text = data['user']['email'] ?? '';
          notifyListeners();
        } else {
          throw Exception('User data not found');
        }
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveProfile(int userId) async {
    if (userId <= 0) throw Exception('Invalid userId provided');

    final updatedProfile = {
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'phonenumber': phoneController.text.trim(),
      'email': emailController.text.trim(),
    };

    _setLoading(true);

    try {
      final uri = Uri.parse('http://192.168.0.6:3000/api/update-profile/$userId');
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(updatedProfile),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void clearControllers() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  @override
  void dispose() {
    clearControllers();
    super.dispose();
  }
}
