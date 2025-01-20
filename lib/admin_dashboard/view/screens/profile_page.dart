import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/menu_controller.dart' as custom;
import '../../controllers/navigation_controller.dart' as nav;



import '../../view_model/profile_vm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  late ProfileViewModel profileViewModel;

  @override
  void initState() {
    super.initState();
    profileViewModel = Get.put(ProfileViewModel());
    profileViewModel.loadAdminData();
  }

  void _toggleEditMode() {
    setState(() {
      if (isEditing) {
        profileViewModel.updateProfile();
      }
      isEditing = !isEditing;
    });
  }

  void _updatePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: profileViewModel.currentPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: profileViewModel.newPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: profileViewModel.confirmPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Execute password update logic
              profileViewModel.updatePassword();
            },
            child: Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    custom.MenuController menuController = custom.MenuController.instance;
    nav.NavigationController navigationController = nav.NavigationController.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF008080),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROFILE',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(isEditing ? Icons.done : Icons.edit, color: Colors.white),
              onPressed: _toggleEditMode,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField('Name', profileViewModel.name, isEditing, false),
            SizedBox(height: 16),
            _buildProfileField('Email', profileViewModel.email, isEditing, false),
            SizedBox(height: 16),
            _buildProfileField('Phone Number', profileViewModel.phone, isEditing, false),
            SizedBox(height: 16),
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool isEditing, bool isSecure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        isEditing
          ? TextField(
              controller: controller,
              style: TextStyle(fontSize: 18),
              obscureText: isSecure,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '', 
              ),
            )
          : Text(
              controller.text.isEmpty ? '**********' : controller.text,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        isEditing
          ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row( // Use Row to wrap Expanded and other widgets
              children: [
                Expanded(
                  child: Text(
                    profileViewModel.password.text.isEmpty
                        ? '**********'
                        : '**********',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black87),
                  onPressed: _updatePassword,
                ),
              ],
            ),
          )
          : Text(
              profileViewModel.password.text.isEmpty
                  ? '**********'
                  : profileViewModel.password.text,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
      ],
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:workshop_2/admin_dashboard/controllers/menu_controller.dart' as custom;
import 'package:workshop_2/admin_dashboard/controllers/navigation_controller.dart' as nav;
import 'package:workshop_2/admin_dashboard/utils/message_util.dart';
import 'package:workshop_2/admin_dashboard/controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  ProfileController profileController = Get.put(ProfileController());

  void _toggleEditMode() {
    setState(() {
      if (isEditing) {
        profileController.updateProfile();
      }
      isEditing = !isEditing;
    });
  }

  void _updatePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: profileController.currentPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: profileController.newPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: profileController.confirmPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 执行密码更新逻辑
              profileController.updatePassword();
            },
            child: Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    profileController.loadAdminData();
  }

  @override
  Widget build(BuildContext context) {
    custom.MenuController menuController = custom.MenuController.instance;
    nav.NavigationController navigationController = nav.NavigationController.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF008080),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROFILE',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(isEditing ? Icons.done : Icons.edit, color: Colors.white),
              onPressed: _toggleEditMode,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField('Name', profileController.name, isEditing, false),
            SizedBox(height: 16),
            _buildProfileField('Email', profileController.email, isEditing, false),
            SizedBox(height: 16),
            _buildProfileField('Phone Number', profileController.phone, isEditing, false),
            SizedBox(height: 16),
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool isEditing, bool isSecure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        isEditing
          ? TextField(
              controller: controller,
              style: TextStyle(fontSize: 18),
              obscureText: isSecure,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '', 
              ),
            )
          : Text(
              controller.text.isEmpty ? '**********' : controller.text,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        isEditing
          ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row( // Use Row to wrap Expanded and other widgets
              children: [
                Expanded(
                  child: Text(
                    profileController.password.text.isEmpty
                        ? '**********'
                        : '**********',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black87),
                  onPressed: _updatePassword,
                ),
              ],
            ),
          )
          /*GestureDetector(
              onTap: _updatePassword,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        profileController.password.text.isEmpty
                            ? '**********'
                            : '**********',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
              ),
            )*/
          : Text(
              profileController.password.text.isEmpty
                  ? '**********'
                  : profileController.password.text,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
      ],
    );
  }
}*/
