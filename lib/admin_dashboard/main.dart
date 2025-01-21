import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tab_bar_widget/admin_dashboard/view/screens/login_page.dart';
import '../admin_dashboard/controllers/menu_controller.dart' as menu_controller;
import '../admin_dashboard/controllers/navigation_controller.dart' as navigation_controller;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routing/routes.dart';
import 'view/screens/layout.dart';
import 'view/screens/profile_page.dart';


void main() async{
  
  Get.put(menu_controller.MenuController());
  Get.put(navigation_controller.NavigationController());
  await GetStorage.init();
  // website: https://myduit.netlify.app/
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
        GetPage(name: logoutPageRoute, page: () => LoginPage()),
        GetPage(name: profilePageRoute, page: () => ProfilePage(),),
        GetPage(name: notificationPageRoute, page: () => const SiteLayout())
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