import 'package:flutter/material.dart';
import 'package:workshop_2/admin_dashboard/login_page.dart';
import 'package:workshop_2/admin_dashboard/profile_page.dart';
import 'package:workshop_2/admin_dashboard/post_page.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case postPageRoute:
      return _getPageRoute(PostPage());
    case logoutPageRoute:
      return _getPageRoute(const LoginPage());
    case profilePageRoute:
      return _getPageRoute(const ProfilePage());
    default:
      return _getPageRoute(PostPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}