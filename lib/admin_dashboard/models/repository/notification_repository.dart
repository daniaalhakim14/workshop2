//import 'dart:io';
import 'dart:html' as html;

import 'package:workshop_2/admin_dashboard/models/model/notification.dart';
import 'package:workshop_2/admin_dashboard/models/services/notification_service.dart';
import 'package:workshop_2/admin_dashboard/models/services/base_service.dart';
import 'package:get_storage/get_storage.dart';


class NotificationRepository {

  final NotificationService _notificationService = NotificationService();

  // get all notification -> response notification list
  Future<List<Notification>?> fetchNotifications() async {
    Map<String, dynamic>? serverResponse = await _notificationService.getResponse('');
    if (serverResponse != null && serverResponse['data'] != null) {
      final List<dynamic> data = serverResponse['data'];
      return data.map((json) => Notification.fromJson(json)).toList();
    }
    return null;
  }

  
  // Add notification -> request notification details, response success message
  Future<bool> addNotification(Notification notification) async {

    try {
      
      Map<String, dynamic> requestBody = notification.toJson();
      Map<String, dynamic>? serverResponse = await _notificationService.postResponse('', requestBody);

 
    if (serverResponse != null && serverResponse['errorCode'] == 0) {
      return true; 
    } else if (serverResponse != null && serverResponse['statusCode'] == 201) {
      return true;
    }
    
      return false; 
    } catch (e) {
      print('Error adding notification: $e');
      return false;
    }
  }

  // get notification {date} -> request date, response notification list
  Future<List<Notification>?> fetchNotificationsByDate(String date) async {
    try {
      final endpoint = '/date?date=$date'; 
      Map<String, dynamic>? serverResponse = await _notificationService.getResponse(endpoint);

      if (serverResponse != null && serverResponse['data'] != null) {
        final List<dynamic> data = serverResponse['data'];
        return data.map((json) => Notification.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching notifications by date: $e');
    }
    return null; 
  }

  // update notification -> request notification details, response success message
  Future<Notification?> updateNotification(String notificationID, Notification updatedData) async {
    try {

      Map<String, dynamic> requestBody = updatedData.toJson();
      Map<String, dynamic>? serverResponse = await _notificationService.putResponse(notificationID, requestBody);

      if (serverResponse != null && serverResponse['data'] != null) {
        final updatedNotificationData = serverResponse['data'];

        final box = GetStorage();
        List<dynamic> notifications = box.read('notifications') ?? [];

        int index = notifications.indexWhere((n) => n['notificationID'] == updatedNotificationData['notificationID']);
        if (index != -1) {
          notifications[index] = updatedNotificationData;
          box.write('notifications', notifications);
        }

        return Notification.fromJson(updatedNotificationData);
      }

      return null; 
    } catch (e) {
      print('Error updating notification: $e');
      return null; 
    }
  }

  // delete notification -> request notification id, response success message
    Future<bool> deleteNotification(String notificationID) async {
      try {
        Map<String, dynamic>? serverResponse = 
            await _notificationService.deleteResponse(notificationID);

        if (serverResponse != null && serverResponse['errorCode'] == 0) {
          return true; 
        }

      } catch (e) {
        print('Error deleting notification: $e');
      }

    return false;
  }
  
}
