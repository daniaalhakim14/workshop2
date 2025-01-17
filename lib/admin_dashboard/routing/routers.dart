import 'package:flutter/material.dart';
import '../../View/Main_pages/homepage.dart';
import '../../View/Main_pages/loginpage.dart';
import '../view/screens/profile_page.dart';
import 'routes.dart';


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