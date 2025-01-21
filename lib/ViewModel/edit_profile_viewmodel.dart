import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  bool _isShowingToast = false;

  Future<void> fetchUserDetails(int userId) async {
    if (userId <= 0) throw Exception('Invalid userId provided');

    _setLoading(true);

    try {
      final uri = Uri.parse('http://192.168.0.18:3000/user/user/$userId');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          nameController.text = data['user']['name'] ?? '';
          phoneController.text = data['user']['phonenumber'] ?? '';
          addressController.text = data['user']['address'] ?? '';
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

  Future<void> saveProfile(BuildContext context, int userId) async {
    if (userId <= 0) throw Exception('Invalid userId provided');

    if (!await validateInputs(context)) return;

    final updatedProfile = {
      'name': nameController.text.trim(),
      'phonenumber': phoneController.text.trim(),
      'address': addressController.text.trim(),
    };

    _setLoading(true);

    try {
      final uri = Uri.parse('http://192.168.0.18:3000/profile/update-profile/$userId');
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(updatedProfile),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        _showToast(context, error['message'] ?? 'Failed to update profile');
        throw Exception(error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      _showToast(context, e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> validateInputs(BuildContext context) async {
    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();
    final String address = addressController.text.trim();

    if (name.isEmpty || name.length < 3) {
      _showToast(context, 'Name must have at least 3 characters.');
      return false;
    }

    if (phone.isEmpty || !RegExp(r"^\+?[0-9]{1,4}?[0-9]{7,15}$").hasMatch(phone)) {
      _showToast(context, 'Invalid phone number format. Please check and try again.');
      return false;
    }

    if (address.isEmpty ||
        !RegExp(
            r"^No\.\d{1,4}\s[A-Za-z0-9\s]+,\s[A-Za-z0-9\s]+,\s\d{5},\s[A-Za-z\s]+$")
            .hasMatch(address)) {
      _showToast(
          context, 'Address must be valid (e.g., No.1234 Jalan 2, Taman, 76100, Melaka).');
      return false;
    }

    return true;
  }


  void _showToast(BuildContext context, String message) {
    if (_isShowingToast) return;
    _isShowingToast = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    ).closed.then((_) {
      _isShowingToast = false;
    });
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void clearControllers() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  @override
  void dispose() {
    clearControllers();
    super.dispose();
  }
}