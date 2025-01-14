//import 'dart:io';
//import 'dart:html' as html;

import 'package:workshop_2/admin_dashboard/models/model/notification.dart';
import 'package:workshop_2/admin_dashboard/models/services/notification_service.dart';
import 'package:workshop_2/admin_dashboard/models/services/base_service.dart';
import 'package:get_storage/get_storage.dart';


class NotificationRepository {

  final NotificationService _notificationService = NotificationService();


  /* ----------------- Welfare Program -------------------- */


  // get all notification 
  Future<List<Notification>?> fetchNotifications() async {
    Map<String, dynamic>? serverResponse = await _notificationService.getResponse('');
    if (serverResponse != null && serverResponse['data'] != null) {
      final List<dynamic> data = serverResponse['data'];
      return data.map((json) => Notification.fromJson(json)).toList();
    }
    return null;
  }

  
  // Add notification 
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

  // get notification {date} 
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

  // get all financial aid categories 
  Future<List<Map<String, dynamic>>?> fetchCategories() async {
    try {
      final response = await _notificationService.getResponse('categories'); 
      if (response != null && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return null;
  }


  // get financial aid categories {notificationid} 
  Future<List<Map<String, dynamic>>?> fetchCategoriesByNotificationID(int notificationID) async {
    try {
      final endpoint = '/$notificationID/categories';
      final serverResponse = await _notificationService.getResponse(endpoint);

      if (serverResponse != null && serverResponse['data'] != null) {
        return List<Map<String, dynamic>>.from(serverResponse['data']);
      }
    } catch (e) {
      print('Error fetching categories for notification $notificationID: $e');
    }
    return null;
  }

  // get notifications {financialaidcategoryid}
  Future<List<Notification>?> fetchNotificationsByCategoryID(int categoryID) async {
    try {
      final endpoint = '/category/$categoryID';
      final serverResponse = await _notificationService.getResponse(endpoint);

      if (serverResponse != null && serverResponse['data'] != null) {
        return serverResponse['data']
            .map<Notification>((json) => Notification.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error fetching notifications for category $categoryID: $e');
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

  // update financial aid category -> request notificationid and financialaids, response success message
  Future<bool> updateNotificationCategories(int notificationID, List<int> categoryIDs) async {
    try {
      Map<String, dynamic> requestBody = {
        'financialaidcategoryids': categoryIDs,
      };
      Map<String, dynamic>? serverResponse =
          await _notificationService.putResponse('$notificationID/categories', requestBody);

      return serverResponse != null && serverResponse['errorCode'] == 0;
    } catch (e) {
      print('Error updating notification categories: $e');
      return false;
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


  /* ----------------- Transaction -------------------- */

  // get transaction notification {userid} -> request userid, response notification list
  Future<List<Notification>?> fetchNotificationsByUserID(String userID) async {
    try {
      final endpoint = '/transaction/$userID'; 
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

  // auto send transaction alert notification (When expense reach 50%/70%/90%/100% of budget)
  // -> request userid, response message 

  Future<bool> sendTransactionAlertNotification(String userID) async {
    try {

      Map<String, dynamic> requestBody = {
        'userid': userID,
      };

      Map<String, dynamic>? serverResponse = await _notificationService.postResponse('/check-budget', requestBody);

      if (serverResponse != null && serverResponse['errorCode'] == 0) {
        print('Transaction alert notification sent successfully for userID: $userID');
        return true;
      } else {
        print('Failed to send transaction alert notification: ${serverResponse?['message']}');
        return false;
      }
    } catch (e) {
      print('Error sending transaction alert notification: $e');
      return false;
    }
  }


  
}
