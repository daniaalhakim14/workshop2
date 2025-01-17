import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../apis/app_exception.dart';


class AdminService{

  final String adminBaseUrl = "http://localhost:3000/admin";


  Future getResponse(String endpoint) async {
    Map<String, dynamic>? responseJson;
    try {
      final response = await http.get(Uri.parse('$adminBaseUrl/$endpoint'));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  Future postResponse(String endpoint, Map<String, dynamic> body) async {
    Map<String, dynamic>? responseJson;

    try {
      final response = await http.post(
        Uri.parse('$adminBaseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future putResponse(String endpoint, Map<String, dynamic> body) async {
    Map<String, dynamic>? responseJson;
    try {
      final response = await http.put(
        Uri.parse('$adminBaseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future deleteResponse(String endpoint) async {
    Map<String, dynamic>? responseJson;
    try {
      final response = await http.delete(Uri.parse('$adminBaseUrl/$endpoint'));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @visibleForTesting
  Map<String, dynamic> returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw NotFoundException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }

 
}