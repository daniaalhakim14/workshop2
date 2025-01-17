// Service class
import 'dart:convert';

import 'package:http/http.dart'as http;

class CallingApi {
// Indicates that the function is asynchronous and does not return a value.
// Instead, it returns a Future, which represents a potential value or error that will be available at some point in the future.
  final String baseUrl = 'http://192.168.0.12:3000';

  Future<http.Response> login(String email, String password) async {
    final String endpoint = '/appuser/login';
    final String url = '$baseUrl$endpoint';
    return await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  // Fetch user details by email
  Future<http.Response> fetchUserDetailsByEmail(String email) async {
    final String endpoint = '/appuser/email/$email'; // Endpoint for fetching user details by email
    final String url = '$baseUrl$endpoint';

    return await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
  }

  Future<http.Response> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {

    final String endpoint = '/appuser/signup';
    final String url = '$baseUrl$endpoint';

    return await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phonenumber': phone,
        'password': password,
        'address': address,
      }),
    );
  }

}
