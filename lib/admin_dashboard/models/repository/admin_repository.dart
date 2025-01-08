import 'package:workshop_2/admin_dashboard/models/model/admin.dart';
import 'package:workshop_2/admin_dashboard/models/services/admin_service.dart';
import 'package:workshop_2/admin_dashboard/models/services/base_service.dart';
import 'package:get_storage/get_storage.dart';
class AdminRepository {
  final BaseService _adminService = AdminService();

  // login -> request email & password, response admin data & token
  Future<Admin?> loginAdmin(Map<String, dynamic> adminData) async {
    Map<String, dynamic>? serverResponse = await _adminService.postResponse('login', adminData);

    if (serverResponse != null && serverResponse['data'] != null) {
      final data = serverResponse['data'];
      final adminData = data['adminData'];
      final token = data['token'];

      if (adminData != null) {
        final box = GetStorage();
        box.write('adminData', {
          'adminid': adminData['adminid'],
          'name': adminData['name'],
          'email': adminData['email'],
          'phonenumber': adminData['phonenumber'],
          'token': token, 
        });

        return Admin.fromJson(adminData);
      }
    }
    return null;
  }


  // update admin (edit) -> request admin id and updated data, response success message
  Future<Admin?> updateProfile(String adminId, Map<String, dynamic> updatedData) async {
    
    Map<String, dynamic>? serverResponse = await _adminService.putResponse(adminId, updatedData,);

    if (serverResponse != null && serverResponse['data'] != null) {
      final updatedAdminData = serverResponse['data'];

      final box = GetStorage();
      box.write('adminData', {
        'adminid': updatedAdminData['adminid'],
        'name': updatedAdminData['name'],
        'email': updatedAdminData['email'],
        'phonenumber': updatedAdminData['phonenumber'],
        'token': box.read('adminData')['token'], 
      });

      return Admin.fromJson(updatedAdminData);
    }

    return null;
  }

  // update password (edit) -> request admin id and password, response success message
  Future<bool> updatePassword(String adminId, String currentPassword, String newPassword) async {
    
    final box = GetStorage();
    final storedAdminData = box.read('adminData');

    if (storedAdminData == null || storedAdminData['adminid'] == null) {
      throw Exception('Admin ID not found in local storage.');
    }

    try {
      // Prepare the data for updating the password
      final response = await _adminService.putResponse(
        'password/$adminId',
        {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response != null && response['data'] != null) {
        return true;
      }

      return false;
    } catch (e) {
      //print("Error: $e");
      return false;
    }
  }

}
