import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workshop_2/admin_dashboard/utils/message_util.dart';
import 'package:workshop_2/admin_dashboard/models/model/notification.dart' as nt;
import 'package:workshop_2/admin_dashboard/models/repository/notification_repository.dart';

class NotificationViewModel extends GetxController {
  final NotificationRepository notificationRepository = NotificationRepository();

  // Reactive state for notifications
  final RxList<nt.Notification> _notifications = <nt.Notification>[].obs;
  List<nt.Notification> get notifications => _notifications;

  // Reactive state for selected date
  final RxString _selectedDate = 'Select Date'.obs;
  String get selectedDate => _selectedDate.value;

  /// Fetch notifications from the repository
  Future<void> fetchNotifications() async {
    try {
      print('Fetching notifications...');
      List<nt.Notification>? result = await notificationRepository.fetchNotifications();
      if (result != null) {
        print('Notifications fetched: ${result.length}');
        _notifications.assignAll(result);
      } else {
        print('No notifications fetched');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  /// Update the selected date
  void updateSelectedDate(String date) {
    _selectedDate.value = date; // Updates the reactive variable
  }

  Future<void> fetchNotificationsByDate(String? date) async {
    try {
      List<nt.Notification>? result;
      if (date == null || date.isEmpty) {
        // Fetch all notifications if no date is selected
        result = await notificationRepository.fetchNotifications();
      } else {
        // Fetch notifications by date
        result = await notificationRepository.fetchNotificationsByDate(date);
      }

      if (result != null) {
        _notifications.assignAll(result);
      } else {
        _notifications.clear(); // Clear the list if no notifications are found
      }
    } catch (e) {
      print('Error fetching notifications by date: $e');
    }
  }


  /// Add a new notification
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

  /// Update an existing notification
  Future<bool> updateNotification(String notificationID, nt.Notification updatedData) async {
    try {
      nt.Notification? updatedNotification = await notificationRepository.updateNotification(notificationID, updatedData);
      if (updatedNotification != null) {
        int index = _notifications.indexWhere((n) => n.notificationID == updatedNotification.notificationID);
        if (index != -1) {
          _notifications[index] = updatedNotification;
          _notifications.refresh(); // Notify listeners
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

  /// Delete a notification
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
}

/*
class NotificationViewModel extends GetxController{
  
  final NotificationRepository notificationRepository = NotificationRepository();

    
    RxList<nt.Notification> _notifications = <nt.Notification>[].obs; // RxList for reactive state
    List<nt.Notification> get notifications => _notifications;

    RxString _selectedDate = 'Select Date'.obs; // RxString for reactive state
    String get selectedDate => _selectedDate.value;

    // Fetch notifications
    /*
    Future<void> fetchNotifications() async {
      List<nt.Notification>? result = await notificationRepository.fetchNotifications();
      if (result != null) {
        _notifications.assignAll(result);
      }
    }*/

    Future<void> fetchNotifications() async {
      print('Fetching notifications...');
      List<nt.Notification>? result = await notificationRepository.fetchNotifications();
      if (result != null) {
        print('Notifications fetched: ${result.length}');
        _notifications.assignAll(result);
      } else {
        print('No notifications fetched');
      }
    }


    // Update selected date
    void updateSelectedDate(String date) {
      _selectedDate.value = date; // Updates the reactive variable
    }

    // Add notification
  Future<bool> addNotification(nt.Notification notification) async {
    try {
      
      bool success = await notificationRepository.addNotification(notification);
      if (success) {
        // 如果添加成功，重新获取通知列表
        await fetchNotifications();
      } 
      return success;
    } catch (e) {
      print('添加通知时出错: $e');
      return false;
    }
  }


  /*

  // Add notification

  
  Future<bool> addNotification(Notification notification) async {
    bool success = await notificationRepository.addNotification(notification);
    if (success) {
      await fetchNotifications(); // Refresh the list after adding
    }
    return success;
  }*/

  
  // Update notification
  Future<bool> updateNotification(String notificationID, Map<String, dynamic> updatedData) async {
    final updatedNotification = await notificationRepository.updateNotification(notificationID, updatedData);
    if (updatedNotification != null) {
      // Find and update the notification in the list
      int index = notifications.indexWhere((n) => n.notificationID == updatedNotification.notificationID);
      if (index != -1) {
        notifications[index] = updatedNotification;
        notifications.refresh();
        return true;
      }
    }
    return false;
  }

  // Delete notification
  Future<bool> deleteNotification(String id) async {
    bool success = await notificationRepository.deleteNotification(id);
    if (success) {
      await fetchNotifications(); // Refresh the list after deletion
    }
    return success;
  }
}*/