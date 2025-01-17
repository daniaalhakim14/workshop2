import 'package:flutter/material.dart';
import '../../controllers/menu_controller.dart' as custom;
import '../../controllers/navigation_controller.dart' as nav;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routing/routes.dart';
import '../../view_model/profile_vm.dart';
import 'custom_text.dart';
import 'horizontal_menu_item.dart';


class SideMenu extends StatelessWidget{
  
  const SideMenu({super.key});
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    custom.MenuController menuController = custom.MenuController.instance;
    nav.NavigationController navigationController = nav.NavigationController.instance;

    final profileViewModel = Get.put(ProfileViewModel());

    final box = GetStorage();
    final adminData = box.read('adminData'); 
    final adminName = adminData?['name'] ?? "Admin Name"; 

    return Container(
      color: const Color(0xFF008080), //background color
      child: ListView( 
        children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(child: Text(
                        'MY DUIT',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),),
                      const SizedBox(height: 15),
                      CircleAvatar(
                        radius: 50,
                        child: Image.asset("lib/Icons/admin.png"),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => CustomText( // 使用 Obx 监听 adminName
                            text: profileViewModel.adminName.value,
                            color: Colors.white,
                            size: 20,
                            weight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            
            Column(
            mainAxisSize: MainAxisSize.min, 
            children: sideMenuItemRoutes 
                .map((item) => HorizontalMenuItem(
                      itemName: item.name, 
                      onTap: () {
                        if (item.route == logoutPageRoute) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Logout"),
                                content: const Text("Are you sure you want to log out?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); 
                                      Get.offAllNamed(logoutPageRoute);
                                      menuController.changeActiveItemTo(notificationPageRouteName); 
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              );
                            },
                          );}
                        else{
                          //navigate to other
                          if (!menuController.isActive(item.name)) {
                            menuController.changeActiveItemTo(item.name);
                            //navigate
                            navigationController.navigateTo(item.route);
                        }
                        }
                        
                      },
                    ))
                .toList(), 
          ),
        ],
      ),
    );
    
  }
}