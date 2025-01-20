import 'dart:convert';
import '../../Model/SignupLoginPage_model.dart';
import 'SignupLoginPage_Calling_API.dart';

class SignuploginpageRepository {
  final CallingApi _service = CallingApi();

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    final response = await _service.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
      address: address,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Signup failed with status: ${response.statusCode}');
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await _service.login(email, password);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //print('Login successful: ${data['user']}');
      return true;
    } else {
      print('Login failed with status: ${response.statusCode}');
      return false;
    }
  }

// Fetch user details using email
  Future<UserInfoModule?> fetchUserDetailsByEmail(String email) async {
    final response = await _service.fetchUserDetailsByEmail(email);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Fetched User Details: ${data['user']}');
      return UserInfoModule.fromJson(data['user']);
    } else {
      print('Failed to fetch user details with status: ${response.statusCode}');
      return null;
    }
  }
}