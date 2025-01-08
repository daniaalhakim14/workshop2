import 'package:flutter/material.dart';
import 'package:workshop_2/admin_dashboard/view/screens/login_page.dart';
import 'package:workshop_2/admin_dashboard/view/screens/profile_page.dart';
import 'package:workshop_2/admin_dashboard/view/screens/notification_page.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case notificationPageRoute:
      return _getPageRoute(NotificationPage());
    case logoutPageRoute:
      return _getPageRoute(LoginPage());
    case profilePageRoute:
      return _getPageRoute(const ProfilePage());
    default:
      return _getPageRoute(NotificationPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}