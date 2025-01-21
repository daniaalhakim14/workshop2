import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../../configure_API.dart';
import '../apis/app_exception.dart';


class NotificationService {

   final Dio _dio = Dio();
   final String notificationBaseUrl = "${AppConfig.baseUrl}/notification";
   /* final String notificationBaseUrl = "http://localhost:3000/notification";*/
  
  
  Future getResponse(String endpoint) async {
    Map<String, dynamic>? responseJson;
    try {
      final response = await http.get(Uri.parse('$notificationBaseUrl/$endpoint'));
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
        Uri.parse('$notificationBaseUrl/$endpoint'),
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
        Uri.parse('$notificationBaseUrl/$endpoint'),
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
      final response = await http.delete(Uri.parse('$notificationBaseUrl/$endpoint'));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  /*
 Future<String?> uploadImage(html.File imageFile) async {
  try {

    final reader = html.FileReader();
    reader.readAsArrayBuffer(imageFile);  
    await reader.onLoadEnd.first;  

    final byteData = reader.result as Uint8List; 

    final formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(byteData, filename: imageFile.name),  
      "upload_preset": "notificationImage", 
    });

    final response = await Dio().post(
      "https://api.cloudinary.com/v1_1/disfofeam/image/upload",
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['secure_url'];  
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      return null;
    }
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}*/

  @visibleForTesting
  Map<String, dynamic> returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
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