import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/large_screen.dart';
import '../widgets/side_menu.dart';
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