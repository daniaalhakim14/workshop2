import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../configure_API.dart';

class CallingApi {
  final http.Client _httpClient = http.Client();

  Future<http.Response> fetchIncomeAmount(int userid) async {
    String endpoint = '/income/$userid';
    String url = '${AppConfig.baseUrl}$endpoint';
    return await http.get(Uri.parse(url));
  }

  void dispose(){
    _httpClient.close(); // Close the HTTP client to release resources
    print("HTTP client closed.");
  }
}
