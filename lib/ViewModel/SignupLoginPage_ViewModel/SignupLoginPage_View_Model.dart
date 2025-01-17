// A bridge between view layer and repository (data layer)

import 'package:flutter/material.dart';
import '../../Model/SignupLoginPage_model.dart';
import 'SignupLoginPage_Repository.dart';


class SignupLoginPage_ViewModule extends ChangeNotifier{

  final SignuploginpageRepository _repository = SignuploginpageRepository(); // Initialize repository
  bool fetchingData = false;

  UserInfoModule? _userInfo;
  UserInfoModule? get userInfo => _userInfo;

  // For signupa page use
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? repeatPasswordError;
  String? addressError;

  void resetErrors() {
    nameError = null;
    emailError = null;
    phoneError = null;
    passwordError = null;
    repeatPasswordError = null;
    addressError = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final success = await _repository.login(email, password);
      return success;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  // Fetch user details using email
  Future<void> fetchUserDetailsByEmail(String email) async {
    try {
      _userInfo = await _repository.fetchUserDetailsByEmail(email);
      if (_userInfo != null) {
        print('User details fetched successfully: ${_userInfo!.toJson()}');
      } else {
        print('Failed to fetch user details');
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String repeatPassword,
    required String address,
  }) async {
    resetErrors();

    // Validate inputs
    if (name.isEmpty || name.length < 3) {
      nameError = 'Name cannot be empty and must be at least 3 characters';
    }
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      emailError = 'Enter a valid email';
    }
    if (phone.isEmpty ||
        !RegExp(r"^\+?[0-9]{1,4}?[0-9]{7,15}$").hasMatch(phone)) {
      phoneError = 'Enter a valid phone number';
    }
    if (password.isEmpty || password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }
    if (repeatPassword.isEmpty || password != repeatPassword) {
      repeatPasswordError = 'Passwords do not match';
    }
    if (address.isEmpty) {
      addressError = 'Address cannot be empty';
    }

    // If there are errors, return false
    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        passwordError != null ||
        repeatPasswordError != null ||
        addressError != null) {
      notifyListeners();
      return false;
    }

    // If no errors, proceed with signup
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
      );

      _isLoading = false;
      notifyListeners();

      return response;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

}
