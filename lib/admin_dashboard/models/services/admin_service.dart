import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:workshop_2/admin_dashboard/models/services/base_service.dart';
import 'package:workshop_2/admin_dashboard/models/apis/app_exception.dart';

class AdminService extends BaseService {

  @override
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

  @override
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

  @override
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

  @override
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