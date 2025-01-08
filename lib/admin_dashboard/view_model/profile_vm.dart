import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:workshop_2/admin_dashboard/utils/message_util.dart';
import 'package:workshop_2/admin_dashboard/models/model/admin.dart';
import 'package:workshop_2/admin_dashboard/models/repository/admin_repository.dart';

class ProfileViewModel extends GetxController {
  final GetStorage box = GetStorage();
  final AdminRepository adminRepository = AdminRepository();

  RxString adminName = ''.obs;

  late Map<String, dynamic> adminData;
  RxBool isEditing = false.obs;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAdminData();
  }

  void loadAdminData() {
    final storedAdminData = box.read('adminData');
    adminData = storedAdminData ?? {};

    name.text = adminData['name'] ?? '';
    email.text = adminData['email'] ?? '';
    phone.text = adminData['phonenumber'] ?? '';
    password.text = adminData['password'] ?? '';

    adminName.value = adminData['name'] ?? "Admin Name"; //
  }

  // update admin (edit) -> request admin id and updated data, response success message
  Future<void> updateProfile() async {
    if (adminData['adminid'] == null) {
      await MessageUtils.showMessage(
        context: Get.context!,
        title: 'Error',
        description: 'Invalid admin data.',
      );
      return;
    }

    String adminId = adminData['adminid'].toString();
    Admin updatedAdmin = Admin(
      adminID: adminData['adminid'],
      name: name.text.trim(),
      email: email.text.trim(),
      phoneNumber: phone.text.trim(),
    );

    try {
      Admin? result = await adminRepository.updateProfile(adminId, updatedAdmin.toJson());
      if (result != null) {
        adminData.addAll(result.toJson());
        box.write('adminData', adminData);
        adminName.value = result.name ?? "";
        
        await MessageUtils.showMessage(
          context: Get.context!,
          title: 'Success',
          description: 'Profile updated successfully.',
        );
      } else {
        throw Exception('Unexpected response');
      }
    } catch (e) {
      print('Error during profile update: $e');
        await MessageUtils.showMessage(
            context: Get.context!,
            title: 'Error',
            description: e.toString(),
        );

    }
  }

   // update password (edit) -> request admin id and password, response success message
  Future<void> updatePassword() async {
    String currentPw = currentPassword.text.trim();
    String newPw = newPassword.text.trim();
    String confirmPw = confirmPassword.text.trim();

    if (newPw != confirmPw) {
      await MessageUtils.showMessage(
        context: Get.context!,
        title: 'Error',
        description: 'Passwords do not match.',
      );
      return;
    }

    String adminId = adminData['adminid'].toString();

    try {
      bool success = await adminRepository.updatePassword(adminId, currentPw, newPw);
      if (success) {
        await MessageUtils.showMessage(
          context: Get.context!,
          title: 'Success',
          description: 'Password updated successfully',
        );
      } else {
        await MessageUtils.showMessage(
          context: Get.context!,
          title: 'Error',
          description: 'Incorrect current password',
        );
      }
    } catch (e) {
        print('Error during profile update: $e'); // 打印调试信息
        await MessageUtils.showMessage(
          context: Get.context!,
          title: 'Error',
          description: e.toString(),
        );
    }
  }
}
