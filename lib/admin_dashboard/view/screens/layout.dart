import 'package:flutter/material.dart';
import 'package:workshop_2/admin_dashboard/view/widgets/large_screen.dart';
import 'package:workshop_2/admin_dashboard/view/widgets/side_menu.dart';
import 'package:workshop_2/admin_dashboard/helpers/local_navigator.dart';
import 'package:get/get.dart';
class SiteLayout extends StatelessWidget{

  const SiteLayout({super.key});



  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();  
    //final String currentRoute = Get.currentRoute;
    return Scaffold(
      key: scaffoldKey,
      //extendBodyBehindAppBar: true,
      //appBar: navigationBar(context,scaffoldKey,currentRoute),
      drawer: const Drawer(
        child: SideMenu(),
      ),
      body: LargeScreen(),
    );
  }
}