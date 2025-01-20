// notification_service.dart
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_client/pusher_client.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late PusherClient pusher;

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
        showNotification(data['title'], data['description']);
      }
    } else {
      print("Event or event data is null");
    }
  });
}

Future<void> showNotification(String title, String body) async {
    print("Showing notification: Title=$title, Body=$body");
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'default_channel',
        'Notification',
        importance: Importance.max, 
        priority: Priority.high);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    body,
    notificationDetails,
  );
}
