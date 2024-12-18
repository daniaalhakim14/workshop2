import 'package:flutter/material.dart';
import 'package:workshop_2/admin_dashboard/menu_controller.dart' as custom;
import 'package:workshop_2/admin_dashboard/navigation_controller.dart' as nav;
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> adminData = {
    'name': 'Admin Name',
    'email': 'admin@example.com',
    'phone': '012-3456789',
    'password': '********',
  };

  bool isEditing = false; 

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController.text = adminData['name']!;
    emailController.text = adminData['email']!;
    phoneController.text = adminData['phone']!;
    passwordController.text = adminData['password']!;
  }

  void _toggleEditMode() {
    setState(() {
      if (isEditing) {
        adminData['name'] = nameController.text;
        adminData['email'] = emailController.text;
        adminData['phone'] = phoneController.text;
        adminData['password'] = passwordController.text;
      }
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    custom.MenuController menuController = custom.MenuController.instance;
    nav.NavigationController navigationController =
        nav.NavigationController.instance;

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
            _buildProfileField('Name', adminData['name']!, isEditing, nameController),
            SizedBox(height: 16),
            _buildProfileField('Email', adminData['email']!, isEditing, emailController),
            SizedBox(height: 16),
            _buildProfileField('Phone Number', adminData['phone']!, isEditing, phoneController),
            SizedBox(height: 16),
            _buildProfileField('Password', adminData['password']!, isEditing, passwordController),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value, bool isEditing,
      TextEditingController controller) {
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '', 
                ),
              )
            : Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
