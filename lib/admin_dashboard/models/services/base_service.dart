import 'dart:typed_data';

abstract class BaseService {
  final String adminBaseUrl = "http://localhost:3000/admin";
  final String notificationBaseUrl = "http://localhost:3000/notification";
  
  Future<dynamic> getResponse(String endpoint);
  Future<dynamic> postResponse(String endpoint, Map<String, dynamic> body);
  Future<dynamic> putResponse(String endpoint, Map<String, dynamic> body);
  Future<dynamic> deleteResponse(String endpoint);
 
}