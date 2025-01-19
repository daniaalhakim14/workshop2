
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../admin_dashboard/models/model/notification.dart' as nt;
import '../models/repository/notification_repository.dart';
import '../utils/message_util.dart';


class NotificationViewModel extends GetxController {
  final NotificationRepository notificationRepository = NotificationRepository();
  
  final RxBool isDescending = true.obs;

  final RxList<nt.Notification> _notifications = <nt.Notification>[].obs;
  List<nt.Notification> get notifications => _notifications;

  final RxString _selectedDate = 'Select Date'.obs;
  String get selectedDate => _selectedDate.value;

  final RxList<Map<String, dynamic>> _financialAidCategories = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get financialAidCategories => _financialAidCategories;

  final RxList<Map<String, dynamic>> _notificationCategories = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get notificationCategories => _notificationCategories;

  var isExpanded = true.obs;
  
  final RxBool isLoading = false.obs;

  final RxString fcmToken = ''.obs;

  bool _isMounted = true;

  @override
  void onClose() {
    _isMounted = false; 
    super.onClose();
  }

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


  /*
  Future<void> initializeNotifications(String userID) async {
    try {
      isLoading.value = true;

      //check the expense percentage in budget, if reach 50%/70%/90%/100% will auto send notification to user
      await autoSendTransactionAlert(userID);
      
      List<nt.Notification>? generalNotifications = await notificationRepository.fetchNotifications();
      List<nt.Notification>? userNotifications = await notificationRepository.fetchNotificationsByUserID(userID);

      if (generalNotifications != null && userNotifications != null) {
        final combinedNotifications = [...generalNotifications, ...userNotifications];
        final uniqueNotifications = combinedNotifications.toSet().toList()
          ..sort((a, b) {
            DateTime dateTimeA = DateTime.parse('${a.date ?? '1970-01-01'} ${a.time ?? '00:00:00'}');
            DateTime dateTimeB = DateTime.parse('${b.date ?? '1970-01-01'} ${b.time ?? '00:00:00'}');
            return dateTimeB.compareTo(dateTimeA);
          });

        _notifications.assignAll(uniqueNotifications);
      } else {
        _notifications.clear();
      }

    } catch (e) {
      print('Error initializing notifications: $e');
    } finally {
      if (_isMounted) {
        isLoading.value = false;
      }

    }
  }*/

  Future<void> initializeNotifications(String userID) async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        autoSendTransactionAlert(userID), 
        notificationRepository.fetchNotifications(), 
        notificationRepository.fetchNotificationsByUserID(userID),
      ]);

      final List<nt.Notification>? generalNotifications = results[1] as List<nt.Notification>?;
      final List<nt.Notification>? userNotifications = results[2] as List<nt.Notification>?;

      if (generalNotifications != null && userNotifications != null) {
        final combinedNotifications = [
          ...generalNotifications,
          ...userNotifications,
        ].toSet().toList(); 

        combinedNotifications.sort((a, b) {
          final dateTimeA = DateTime.parse('${a.date ?? '1970-01-01'} ${a.time ?? '00:00:00'}');
          final dateTimeB = DateTime.parse('${b.date ?? '1970-01-01'} ${b.time ?? '00:00:00'}');
          return dateTimeB.compareTo(dateTimeA); 
        });

        _notifications.assignAll(combinedNotifications);
        _notifications.refresh();
        print('Notification count: ${_notifications.length}');


      } else {
        _notifications.clear();
      }
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
        toggleSortOrder(); 
      } else {
        _notifications.clear();
        print('No notifications fetched');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }




  // get notification {date} 
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

  // get all financial aid categories 
  Future<void> fetchFinancialAidCategories() async {
    try {
      final result = await notificationRepository.fetchCategories();
      if (result != null) {
        _financialAidCategories.assignAll(result);
      } else {
        _financialAidCategories.clear();
      }
    } catch (e) {
      print('Error fetching financial aid categories: $e');
    }
  }

/*
Future<List<Map<String, dynamic>>> fetchCategoriesForNotification(int notificationID) async {
  try {
    final result = await notificationRepository.fetchCategoriesByNotificationID(notificationID);
    if (result != null) {
      _notificationCategories.assignAll(result); // Update the internal state
      return result; // Return the fetched categories
    } else {
      _notificationCategories.clear();
      return [];
    }
  } catch (e) {
    print('Error fetching categories for notification: $e');
    return [];
  }
}*/

Future<List<Map<String, dynamic>>> fetchCategoriesForNotification(int notificationID) async {
  final box = GetStorage();
  final String cacheKey = 'categories_$notificationID';
  
  box.remove(cacheKey);
  
  final cachedData = box.read<List<dynamic>>(cacheKey);
  if (cachedData != null) {
    final categories = cachedData.map((e) => e as Map<String, dynamic>).toList();
    _notificationCategories.assignAll(categories);
    return categories;
  }

  try {
    final result = await notificationRepository.fetchCategoriesByNotificationID(notificationID);
    if (result != null) {
      _notificationCategories.assignAll(result);
      box.write(cacheKey, result);
      return result;
    } else {
      _notificationCategories.clear();
      return [];
    }
  } catch (e) {
    print('Error fetching categories for notification: $e');
    return [];
  }
}

void clearCategoryCache(int notificationID) {
  final box = GetStorage();
  final String cacheKey = 'categories_$notificationID';
  box.remove(cacheKey);
}



  /*
  Future<List<Notification>> fetchNotificationsForCategory(int categoryID) async {
    try {
      final result = await notificationRepository.fetchNotificationsByCategoryID(categoryID);
      if (result != null) {
        return result;
      } else {
        print('No notifications found for category $categoryID');
      }
    } catch (e) {
      print('Error fetching notifications for category: $e');
    }
    return [];
  }*/



  // Add notification -> request notification details, response success message
  Future<bool> addNotification(nt.Notification notification) async {
    try {
      bool success = await notificationRepository.addNotification(notification);
      if (success) {
        print('Notification added successfully');
        await fetchNotifications(); 
      } else {
        print('Failed to add notification');
      }
      return success;
    } catch (e) {
      print('Error adding notification: $e');
      return false;
    }
  }

  Future<void> addNotificationWithMessage({
    required String title,
    required String description,
    required String type,
    required String? imageUrl,
    required int? adminID,
    required List<int> financialAidCategoryIDs,
  }) async {

    if (title.isEmpty || description.isEmpty || type.isEmpty || adminID == null) {
      await MessageUtils.showMessage(
        context: Get.context!,
        title: "Error",
        description: "Please fill in all fields.",
      );
      return;
    }

    final notification = nt.Notification(
      notificationID: null,
      title: title,
      type: type,
      description: description,
      image: imageUrl,
      adminID: adminID,
      date: DateTime.now().toString().split(' ')[0],
      time: DateTime.now().toLocal().toString().split(' ')[1],
      financialAidCategoryIDs: financialAidCategoryIDs, 
    );

    final isSuccess = await addNotification(notification);

    if (isSuccess) {
      Navigator.of(Get.context!).pop();
      MessageUtils.showMessage(
        context: Get.context!,
        title: "Success",
        description: "Notification added successfully.",
      );
    } else {
      MessageUtils.showMessage(
        context: Get.context!,
        title: "Error",
        description: "Failed to add notification.",
      );
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
          await fetchNotifications();
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

  Future<bool> updateNotificationDetailsWithMessage(
    nt.Notification notification,
    String title,
    String description,
    String? imageUrl,
  ) async {
    if (title.trim().isEmpty || description.trim().isEmpty) {
      await MessageUtils.showMessage(
        context: Get.context!,
        title: "Error",
        description: "Title and description cannot be empty.",
      );
      return false; 
    }

    try {
      notification.title = title.trim();
      notification.description = description.trim();
      notification.image = imageUrl;

      final bool isUpdated = await updateNotification(notification.notificationID.toString(), notification);

      if (isUpdated) {
        Navigator.of(Get.context!).pop();
        Navigator.of(Get.context!).pop();
        MessageUtils.showMessage(
          context: Get.context!,
          title: "Success",
          description: "Notification updated successfully.",
        );
        return true;
      } else {
        await MessageUtils.showMessage(
          context: Get.context!,
          title: "Error",
          description: "Failed to update notification.",
        );
        return false;
      }
    } catch (e) {
      print('Error updating notification details: $e');
      await MessageUtils.showMessage(
        context: Get.context!,
        title: "Error",
        description: e.toString(),
      );
    }
    return false;
  }

  // update financial aid category -> request notificationid and financialaids, response success message
  Future<void> updateNotificationCategories(int notificationID, List<int> categoryIDs) async {
    try {
      bool success = await notificationRepository.updateNotificationCategories(notificationID, categoryIDs);
      if (success) {
        clearCategoryCache(notificationID);
        
        await fetchNotifications();
        print('Notification categories updated successfully');
      } else {
        print('Failed to update notification categories');
      }
    } catch (e) {
      print('Error updating notification categories: $e');
    }
  }



  // delete notification -> request notification id, response success message
  Future<bool> deleteNotification(String id) async {
    try {
      bool success = await notificationRepository.deleteNotification(id);
      if (success) {
        print('Notification deleted successfully');
        await fetchNotifications(); 
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
