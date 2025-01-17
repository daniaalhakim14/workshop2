import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routing/routes.dart';

// manage state and behaviour of side menu
// handle icon

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = notificationPageRouteName.obs;
  var hoverItem = "".obs;

  void changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  void onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  bool isActive(String itemName) => activeItem.value == itemName;
  bool isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case notificationPageRouteName:
        return _customIcon("lib/Icons/post.png", itemName);
      case profilePageRouteName:
        return _customIcon("lib/Icons/profile.png", itemName);
      case logoutPageRoute:
        return _customIcon("lib/Icons/logout.png", itemName);
      default:
        return _customIcon("lib/Icons/logout.png", itemName);
    }
  }

  Widget _customIcon(String assetPath, String itemName) {
    return Image.asset(
      assetPath,
      width: isActive(itemName) ? 30 : 22,
      height: isActive(itemName) ? 30 : 22,
      color: isActive(itemName)
          ? Colors.white
          : isHovering(itemName)
              ? const Color(0xFF002B36)
              : Colors.white,
    );
  }
}
