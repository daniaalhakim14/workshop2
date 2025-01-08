import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workshop_2/admin_dashboard/utils/message_util.dart';
import 'package:workshop_2/admin_dashboard/models/model/notification.dart' as nt;
import 'package:workshop_2/admin_dashboard/models/repository/notification_repository.dart';

class NotificationViewModel extends GetxController {
  final NotificationRepository notificationRepository = NotificationRepository();

  final RxList<nt.Notification> _notifications = <nt.Notification>[].obs;
  List<nt.Notification> get notifications => _notifications;

  final RxString _selectedDate = 'Select Date'.obs;
  String get selectedDate => _selectedDate.value;

  void updateSelectedDate(String date) {
    _selectedDate.value = date;
  }

  // get all notification -> response notification list
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
}
