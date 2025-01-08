import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:workshop_2/admin_dashboard/models/model/admin.dart';
import 'package:workshop_2/admin_dashboard/models/repository/admin_repository.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workshop_2/admin_dashboard/routing/routes.dart';
import 'package:workshop_2/admin_dashboard/models/services/admin_service.dart';
import 'package:workshop_2/admin_dashboard/models/apis/app_exception.dart';

class LoginViewModel extends GetxController {
  final AdminRepository _adminRepository = AdminRepository();
  
  RxString _message = ''.obs;
  Rx<Admin?> _currentAdmin = Rx<Admin?>(null);

  String get message => _message.value;
  Admin? get currentAdmin => _currentAdmin.value;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setMessage(String msg) => _message.value = msg;

  bool validateAdmin(Admin admin) {

    if ((admin.email == null || admin.email!.isEmpty) && 
        (admin.password == null || admin.password!.isEmpty)) {
      setMessage("Email or password cannot be empty");
      return false;
    }
    if (admin.password!.isEmpty) {
      setMessage("Password cannot be empty");
      return false;
    }
    /*
    if (admin.email == null || admin.password == null) {
      setMessage("Email or password cannot be empty");
      return false;
    }else{
      if (admin.email!.isEmpty) {
      setMessage("Email cannot be empty");
      return false;
    }

    if (admin.password!.isEmpty) {
      setMessage("Password cannot be empty");
      return false;
    }
    }*/

    

    return true;
  }

  Future<void> loginAdmin() async {
    try {
      Admin admin = Admin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (validateAdmin(admin)) {
        _currentAdmin.value = await _adminRepository.loginAdmin({
          'email': admin.email,
          'password': admin.password,
        });

        if (_currentAdmin.value != null) {
          _showMessage(title: 'Login Successful', description: 'Welcome Back to Admin Dashboard.');
          Get.offAllNamed(notificationPageRoute);
        } else {
          _showMessage(title: 'Error', description: 'Incorrect Email or Password');
        }
      }
      else{
        _showMessage(title: 'Error', description: _message.value);
      }
      
    } on BadRequestException {
      _showMessage(title: 'Error', description: 'Invalid Email or Password');
    } on NotFoundException{
      _showMessage(title: 'Error', description: 'Invalid Email or Password');
    }
    catch (e) {
      if (e is FetchDataException) {
        setMessage("Fetch Data Error: $e");
      } else {
        setMessage("Unexpected Error: $e");
      }
      _showMessage(title: 'Error', description: _message.value);
    }

  }

  void _showMessage({required String title, required String description}) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          CupertinoDialogAction(
            child: Text('Ok'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
