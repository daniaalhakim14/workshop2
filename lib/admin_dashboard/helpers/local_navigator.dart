import 'package:flutter/cupertino.dart';
import 'package:workshop_2/admin_dashboard/menu_controller.dart'as custom;
import 'package:workshop_2/admin_dashboard/navigation_controller.dart'as nav;
import 'package:workshop_2/admin_dashboard/routing/routers.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';

custom.MenuController menuController = custom.MenuController.instance;
nav.NavigationController navigationController = nav.NavigationController.instance;

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: postPageRoute,
);