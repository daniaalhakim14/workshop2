// notification_service.dart
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';

import '../../../View/Notification_page/notification_details_page.dart';
import '../../view_model/notification_vm.dart';
import '../../../main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late PusherClient pusher;

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        await handleNotificationClick(response.payload);
      }
    },
  );
}

Future<void> handleNotificationClick(String? payload) async {
  print('Received payload: $payload'); 
  if (payload == null || payload.isEmpty) {
    print('Payload is null or empty');
    return;
  }
  final viewModel = Get.find<NotificationViewModel>(); 
  final notification = await viewModel.fetchNotificationsById(payload);

  if (notification != null) {
    //final BuildContext? context = Get.context; 
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => NotificatioNDetails(notification: notification),
        ),
      );
  } else {
    print('No details available for notification ID: $payload');
  }
}

void initPusher() {
  PusherOptions options = PusherOptions(cluster: 'ap1');
  pusher = PusherClient(
    'ad5eaea9bc88a024a621',
    options,
    autoConnect: true,
  );

  pusher.connect();
}

void listenToNotifications() {
  Channel channel = pusher.subscribe('notifications');
  channel.bind('new_notification', (event) {
    print("Event received: ${event?.data}");
    if (event != null && event.data != null) {
      final data = jsonDecode(event.data!);
      if (data is Map<String, dynamic>) {
        int notificationID = data['notificationid'];
        showNotification(data['title'], data['description'],notificationID);
      }
    } else {
      print("Event or event data is null");
    }
  });
}

Future<void> showNotification(String title, String body, int notificationID) async {
    print("Showing notification: Title=$title, Body=$body");
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'default_channel',
        'Notification',
        importance: Importance.max, 
        priority: Priority.high);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  //int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  await flutterLocalNotificationsPlugin.show(
    notificationID,
    title,
    body,
    notificationDetails,
    payload: notificationID.toString(),
  );
}
