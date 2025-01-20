import 'package:flutter/material.dart';
import '../view/screens/login_page.dart';
import '../view/screens/profile_page.dart';
import '../view/screens/notification_page.dart';
import 'routes.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case notificationPageRoute:
      return _getPageRoute(const NotificationPage());
    case logoutPageRoute:
      return _getPageRoute(const LoginPage());
    case profilePageRoute:
      return _getPageRoute(const ProfilePage());
    default:
      return _getPageRoute(const NotificationPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}