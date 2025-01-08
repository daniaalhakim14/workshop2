
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workshop_2/admin_dashboard/utils/message_util.dart';
import 'package:workshop_2/admin_dashboard/models/model/notification.dart' as nt;
import 'package:workshop_2/admin_dashboard/models/repository/notification_repository.dart';

class NotificationViewModel extends GetxController {
  final NotificationRepository notificationRepository = NotificationRepository();
  
  final RxBool isDescending = true.obs;

  final RxList<nt.Notification> _notifications = <nt.Notification>[].obs;
  List<nt.Notification> get notifications => _notifications;

  final RxString _selectedDate = 'Select Date'.obs;
  String get selectedDate => _selectedDate.value;

  final RxBool isLoading = false.obs;

  void updateSelectedDate(String date) {
    _selectedDate.value = date;
  }

  void toggleSortOrder() {
    isDescending.value = !isDescending.value; 
    _notifications.sort((a, b) {
      DateTime dateTimeA = DateTime.parse('${a.date ?? '1970-01-01'} ${a.time ?? '00:00:00'}');
      DateTime dateTimeB = DateTime.parse('${b.date ?? '1970-01-01'} ${b.time ?? '00:00:00'}');
      return isDescending.value
          ? dateTimeB.compareTo(dateTimeA) 
          : dateTimeA.compareTo(dateTimeB); 
    });
    _notifications.refresh(); 
  }

  Future<void> initializeNotifications(String userID) async {
    try {
      isLoading.value = true;

      List<nt.Notification>? generalNotifications = await notificationRepository.fetchNotifications();
      List<nt.Notification>? userNotifications = await notificationRepository.fetchNotificationsByUserID(userID);

      final combinedNotifications = [
        ...?_notifications, 
        ...?generalNotifications,
        ...?userNotifications,
      ];

      final uniqueNotifications = combinedNotifications.toSet().toList();
      _notifications.assignAll(uniqueNotifications);

      toggleSortOrder();
    } catch (e) {
      print('Error initializing notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }


  /* ----------------- Welfare Program -------------------- */


  // get all notification -> response notification list
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      print('Fetching notifications...');
      List<nt.Notification>? result = await notificationRepository.fetchNotifications();
      if (result != null) {
        print('Notifications fetched: ${result.length}');
        _notifications.assignAll(result);
        toggleSortOrder(); // 根据当前排序状态重新排序
      } else {
        print('No notifications fetched');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }




  // get notification {date} -> request date, response notification list
  Future<void> fetchNotificationsByDate(String? date) async {
    try {
      List<nt.Notification>? result;
      if (date == null || date.isEmpty) {
        result = await notificationRepository.fetchNotifications();
      } else {
        result = await notificationRepository.fetchNotificationsByDate(date);
      }

      if (result != null) {
        _notifications.assignAll(result);
      } else {
        _notifications.clear(); 
      }
    } catch (e) {
      print('Error fetching notifications by date: $e');
    }
  }

  // Add notification -> request notification details, response success message
  Future<bool> addNotification(nt.Notification notification) async {
    try {
      bool success = await notificationRepository.addNotification(notification);
      if (success) {
        print('Notification added successfully');
        await fetchNotifications(); // Refresh notifications after adding
      } else {
        print('Failed to add notification');
      }
      return success;
    } catch (e) {
      print('Error adding notification: $e');
      return false;
    }
  }

  // update notification -> request notification details, response success message
  Future<bool> updateNotification(String notificationID, nt.Notification updatedData) async {
    try {
      nt.Notification? updatedNotification = await notificationRepository.updateNotification(notificationID, updatedData);
      if (updatedNotification != null) {
        int index = _notifications.indexWhere((n) => n.notificationID == updatedNotification.notificationID);
        if (index != -1) {
          _notifications[index] = updatedNotification;
          _notifications.refresh(); 
          print('Notification updated successfully');
          return true;
        }
      }
      print('Failed to update notification');
      return false;
    } catch (e) {
      print('Error updating notification: $e');
      return false;
    }
  }

  // delete notification -> request notification id, response success message
  Future<bool> deleteNotification(String id) async {
    try {
      bool success = await notificationRepository.deleteNotification(id);
      if (success) {
        print('Notification deleted successfully');
        await fetchNotifications(); // Refresh notifications after deletion
      } else {
        print('Failed to delete notification');
      }
      return success;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }


  /* ----------------- Transaction -------------------- */
  

  // get transaction notification {userid} -> request userid, response notification list
  Future<void> fetchNotificationsByUserID(String userID) async {
    try {
      
      List<nt.Notification>? result;
      result = await notificationRepository.fetchNotificationsByUserID(userID);

      if (result != null) {
        _notifications.assignAll(result);
      } else {
        _notifications.clear(); 
      }
    } catch (e) {
      print('Error fetching notifications by date: $e');
    }
  }

  // auto send transaction alert notification (When expense reach 50%/70%/90%/100% of budget)
  // -> request userid, response message 

  Future<void> autoSendTransactionAlert(String userID) async {

    try {
      isLoading.value = true;
      print('Sending transaction alert notification for UserID: $userID');

      bool success = await notificationRepository.sendTransactionAlertNotification(userID);

      if (success) {
        print('Transaction alert notification sent successfully');
      } else {
        print('Failed to send transaction alert notification');
      }


      await fetchNotificationsByUserID(userID);
    } catch (e) {
      print('Error sending transaction alert notification: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
