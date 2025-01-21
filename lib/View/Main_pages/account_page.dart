import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_bar_widget/View/Main_pages/first_page.dart';
import 'package:tab_bar_widget/View/Main_pages/homepage.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../../ViewModel/account_viewmodel.dart';
import '../../ViewModel/app_appearance_viewmodel.dart';
import '../../admin_dashboard/view/screens/login_page.dart';
import '../Account_page/ChangeEmailPage.dart';
import '../Account_page/app_appearance.dart';
import '../Account_page/change_password.dart';
import '../Account_page/edit_profile_page.dart';
import 'insight_page.dart';
import 'notification_page.dart';

class Account extends StatefulWidget {
  final UserInfoModule userInfo;

  const Account({super.key, required this.userInfo});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final int _selectedIndex = 3;
  bool _showAdditionalOptions = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomePage(userInfo: widget.userInfo),
      Insight(userInfo: widget.userInfo),
      Noti(userInfo: widget.userInfo),
      Account(userInfo: widget.userInfo),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccountViewModel>(context, listen: false)
          .loadAvatar(widget.userInfo.id.toString());
    });
  }

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
    return Consumer<AppAppearanceViewModel>(
      builder: (context, appAppearanceViewModel, child) {
        final accountViewModel =
        Provider.of<AccountViewModel>(context, listen: false);
        final isDarkModeValue = appAppearanceViewModel.isDarkMode;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkModeValue ? Colors.white : Colors.black,
              ),
            ),
            backgroundColor: isDarkModeValue ? Colors.black : const Color(0xFF65ADAD),
            elevation: 0,
            automaticallyImplyLeading: _showAdditionalOptions,
            leading: _showAdditionalOptions
                ? IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isDarkModeValue ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  _showAdditionalOptions = false;
                });
              },
            )
                : null,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: isDarkModeValue ? Colors.black : const Color(0xFF008080),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
        Center(
        child: Consumer<AccountViewModel>(
        builder: (context, accountViewModel, child) {
        return Stack(
        alignment: Alignment.bottomRight,
        children: [
        CircleAvatar(
        key: ValueKey(accountViewModel.avatarBytes != null
        ? DateTime.now().millisecondsSinceEpoch
            : 'default_avatar'), // Unique key to force rebuild
        radius: 83.5,
        backgroundColor: isDarkModeValue ? Colors.grey[800] : Colors.white,
        backgroundImage: accountViewModel.avatarBytes != null
        ? MemoryImage(accountViewModel.avatarBytes!)
            : null,
        child: accountViewModel.avatarBytes == null
        ? Container(
        width: 167,
        height: 167,
        decoration: BoxDecoration(
        color: isDarkModeValue ? Colors.grey[800] : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
        color: Colors.white,
        width: 4,
        ),
        ),
        child: const Center(
        child: Icon(
        Icons.person,
        size: 167,
        color: Colors.black,
        ),
        ),
        )
            : null,
        ),
        GestureDetector(
        onTap: _showAvatarOptions,
        child: CircleAvatar(
        radius: 20,
        backgroundColor:
        isDarkModeValue ? Colors.grey[800] : Colors.white,
        child: Icon(
        Icons.edit,
        size: 18,
        color: isDarkModeValue ? Colors.white : Colors.black,
        ),
        ),
        ),
        ],
        );
        },
        ),
        ),


                  const SizedBox(height: 40),
                  if (!_showAdditionalOptions) ...[
                    buildOptionContainer(
                      title: 'Edit Profile',
                      icon: Icons.edit,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        setState(() {
                          _showAdditionalOptions = true;
                        });
                      },
                    ),
                    buildOptionContainer(
                      title: 'Change Password',
                      icon: Icons.lock,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangePassword(userId: widget.userInfo.id),
                          ),
                        );
                      },
                    ),
                    buildOptionContainer(
                      title: 'App Appearance',
                      icon: Icons.color_lens,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AppAppearance(userId: widget.userInfo.id),
                          ),
                        );
                      },
                    ),
                    buildOptionContainer(
                      title: 'Logout',
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        final accountViewModel = Provider.of<AccountViewModel>(context, listen: false);
                        accountViewModel.clearAvatar();

                        await prefs.clear();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FirstPage(),
                          ),
                        );
                      },
                      alwaysRed: true,
                    ),

                  ] else ...[
                    buildOptionContainer(
                      title: 'Edit Profile Information',
                      icon: Icons.edit,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(userId: widget.userInfo.id),
                          ),
                        );
                      },
                    ),
                    buildOptionContainer(
                      title: 'Change Password',
                      icon: Icons.lock,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangePassword(userId: widget.userInfo.id),
                          ),
                        );
                      },
                    ),
                    buildOptionContainer(
                      title: 'Change Email Address',
                      icon: Icons.email,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeEmailPage(userId: widget.userInfo.id),
                          ),
                        );
                      },
                    ),
                    buildOptionContainer(
                      title: 'Notifications',
                      icon: Icons.notifications,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Noti(userInfo: widget.userInfo,),
                          ),
                        );
                      },
                    ),
                    buildOptionContainer(
                      title: 'Logout',
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      isDarkModeValue: isDarkModeValue,
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        // Log preferences before clearing session-specific data
                        debugPrint('Preferences before logout: isDarkMode = ${prefs.getBool("13-isDarkMode")}');

                        // Clear session-specific data

                        // Navigate to the FirstPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FirstPage(),
                          ),
                        );
                      },
                      alwaysRed: true,
                    ),



                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: isDarkModeValue ? Colors.black : const Color(0xFF002B36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  icon: const Icon(Icons.home_outlined,
                      color: Colors.white, size: 30),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Insight(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'lib/Icons/three lines.png',
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Noti(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'lib/Icons/notification.png',
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'lib/Icons/safe.png',
                    height: 30,
                    width: 30,
                    color: const Color(0xFF65ADAD),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildOptionContainer({
    required String title,
    required IconData icon,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    required bool isDarkModeValue,
    VoidCallback? onTap,
    bool alwaysRed = false,
  }) {

    final effectiveIconColor =
    alwaysRed ? Colors.red : (isDarkModeValue ? Colors.white : iconColor);
    final effectiveTextColor =
    alwaysRed ? Colors.red : (isDarkModeValue ? Colors.white : textColor);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        width: double.infinity,
        height: 51.72,
        decoration: BoxDecoration(
          color: isDarkModeValue ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(icon, color: effectiveIconColor),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: effectiveTextColor,
            ),
          ),
          trailing: Icon(Icons.arrow_forward,
              color: isDarkModeValue ? Colors.white : Colors.black),
        ),
      ),
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
                  _buildModalButton(
                    'Camera',
                    Colors.grey[300]!,
                        () async {
                      final ImagePicker picker = ImagePicker();
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        await _cropImage(File(pickedFile.path));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildModalButton(
                    'Photo',
                    Colors.grey[300]!,
                        () async {
                      final ImagePicker picker = ImagePicker();
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        await _cropImage(File(pickedFile.path));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildModalButton(
                    'Cancel',
                    Colors.grey[300]!,
                        () {
                      Navigator.pop(context);
                    },
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _cropImage(File imageFile) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.teal,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      Navigator.pop(context);

      if (croppedFile != null) {
        final avatarViewModel =
        Provider.of<AccountViewModel>(context, listen: false);

        final updatedFile = File(
            '${croppedFile.path}?v=${DateTime.now().millisecondsSinceEpoch}');

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        await avatarViewModel.uploadAvatar(File(croppedFile.path), widget.userInfo.id.toString());
        await avatarViewModel.fetchAvatar(widget.userInfo.id.toString());


        Navigator.pop(context);

        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded successfully!'),
            backgroundColor: Colors.green,

          ),

        );
        Navigator.pop(context);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image cropping was canceled or failed.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);

      debugPrint('Error during image cropping: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while cropping the image.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
}

