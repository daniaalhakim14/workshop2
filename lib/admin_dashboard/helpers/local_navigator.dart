import 'package:flutter/cupertino.dart';
import '../controllers/menu_controller.dart' as custom;
import '../controllers/navigation_controller.dart' as nav;
import '../routing/routers.dart';
import '../routing/routes.dart';

custom.MenuController menuController = custom.MenuController.instance;
nav.NavigationController navigationController = nav.NavigationController.instance;

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: notificationPageRoute,
);