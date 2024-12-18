import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter/foundation.dart';
import 'package:workshop_2/admin_dashboard/layout.dart';
import 'package:workshop_2/admin_dashboard/login_page.dart';
import 'package:workshop_2/admin_dashboard/menu_controller.dart'as menu_controller;
import 'package:workshop_2/admin_dashboard/navigation_controller.dart'as navigation_controller;
import 'package:get/get.dart';
import 'package:workshop_2/admin_dashboard/post_page.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';



void main() async{
  Get.put(menu_controller.MenuController());
  Get.put(navigation_controller.NavigationController());
  // use "flutter run -d chrome --target=lib/admin_dashboard/main.dart" to run
  runApp(MyWebApp());
}


class MyWebApp extends StatelessWidget {
  
  const MyWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: rootRoute,
      //unknownRoute: GetPage(name: '/not-found', page: () => const PageNotFound(), transition: Transition.fadeIn),
      getPages: [
        GetPage(
            name: rootRoute,
            page: () {
              return LoginPage();
            }),
        GetPage(name: logoutPageRoute, page: () => const LoginPage()),
        GetPage(name: postPageRoute, page: () => const SiteLayout())
      ],
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
        }),
        primaryColor: Colors.teal,
    ),
      );
      
  }
}