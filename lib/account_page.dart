import 'dart:ui';

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'insight_page.dart';
import 'notification_page.dart';
import 'screens/change_password.dart';
import 'screens/app_appearance.dart';
import 'screens/edit_profile_page.dart';



class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final int _selectedIndex = 3;
  bool _showAdditionalOptions = false;

  final List<Widget> _pages = [
    const Home(),
    const Insight(),
    const Noti(),
    const Account(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _showAdditionalOptions = false;
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 83.5,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.person,
                      size: 167,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      _showAvatarOptions();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),


            if (!_showAdditionalOptions) ...[
              buildOptionContainer(
                title: 'Edit Profile',
                icon: Icons.edit,
                onTap: () {
                  setState(() {
                    _showAdditionalOptions = true;
                  });
                },
              ),
              buildOptionContainer(
                title: 'Change Password',
                icon: Icons.lock,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePassword()),
                  );
                },
              ),

              buildOptionContainer(
                title: 'App appearance',
                icon: Icons.color_lens,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppAppearance()),
                  );
                },
              ),
              buildOptionContainer(
                title: 'Logout',
                icon: Icons.logout,
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ] else ...[
              buildOptionContainer(
                title: 'Edit Profile Name',
                icon: Icons.edit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
              ),

              buildOptionContainer(
                title: 'Change Password',
                icon: Icons.lock,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePassword()),
                  );
                },
              ),

              buildOptionContainer(
                title: 'Change Email Address',
                icon: Icons.email,
              ),
              buildOptionContainer(
                title: 'Preferences',
                icon: Icons.settings,
              ),
              buildOptionContainer(
                title: 'Notifications',
                icon: Icons.notifications,
              ),
              buildOptionContainer(
                title: 'Logout',
                icon: Icons.logout,
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF002B36),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF65ADAD),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.insights_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color(0xFF008080),
    );
  }


  void _showAvatarOptions() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Center(
            child: Container(
              width: 348,
              height: 253,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Profile Picture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none, 
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildModalButton('Camera', Colors.grey[300]!, () {}),
                  const SizedBox(height: 10),
                  _buildModalButton('Photo', Colors.grey[300]!, () {}),
                  const SizedBox(height: 10),
                  _buildModalButton('Cancel', Colors.grey[300]!, () {
                    Navigator.pop(context);
                  }, textColor: Colors.red),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalButton(String text, Color color, VoidCallback onTap,
      {Color textColor = Colors.black}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
    );
  }


  Widget buildOptionContainer({
    required String title,
    required IconData icon,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        width: double.infinity,
        height: 51.72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
    );
  }
}
