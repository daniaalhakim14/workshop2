import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_appearance_viewmodel.dart';
import '../../viewmodels/edit_profile_viewmodel.dart';

class EditProfilePage extends StatefulWidget {
  final int userId;

  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    debugPrint('[DEBUG] EditProfilePage Init with userId: ${widget.userId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<EditProfileViewModel>(context, listen: false);
      viewModel.fetchUserDetails(widget.userId).catchError((error) {
        debugPrint('[ERROR] Fetch User Details Failed: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user details: $error')),
        );
      });
    });
  }

  @override
  void dispose() {
    final viewModel = Provider.of<EditProfileViewModel>(context, listen: false);
    viewModel.clearControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAppearanceViewModel>(
      builder: (context, appAppearanceViewModel, child) {
        final isDarkModeValue = appAppearanceViewModel.isDarkMode;

        return Consumer<EditProfileViewModel>(
          builder: (context, viewModel, child) {
            debugPrint(
                '[DEBUG] Rebuilding UI. Is Loading: ${viewModel.isLoading}');
            return Scaffold(
              appBar: AppBar(
                backgroundColor: isDarkModeValue ? Colors.black : Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: isDarkModeValue ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Edit Profile Information',
                  style: TextStyle(
                    color: isDarkModeValue ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              backgroundColor:
              isDarkModeValue ? Colors.black : Colors.white,
              body: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      buildLabel('Full Name', isDarkModeValue),
                      buildInputContainer(
                        controller: viewModel.nameController,
                        width: 351,
                        height: 62,
                        hint: 'Insert New Name',
                        isDarkModeValue: isDarkModeValue,
                      ),
                      const SizedBox(height: 20),
                      buildLabel('Phone Number', isDarkModeValue),
                      buildInputContainer(
                        controller: viewModel.phoneController,
                        width: 351,
                        height: 62,
                        hint: 'Insert Phone Number',
                        isDarkModeValue: isDarkModeValue,
                      ),
                      const SizedBox(height: 20),
                      buildLabel('Address', isDarkModeValue),
                      buildInputContainer(
                        controller: viewModel.addressController,
                        width: 351,
                        height: 122,
                        hint: 'Insert Address',
                        isDarkModeValue: isDarkModeValue,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: 265,
                          height: 53,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: viewModel.isLoading
                                ? null
                                : () async {
                              debugPrint(
                                  '[DEBUG] Calling saveProfile with userId: ${widget.userId}');
                              try {
                                await viewModel.saveProfile(
                                    widget.userId);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Profile updated successfully'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Future.delayed(
                                    const Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                });
                              } catch (error) {
                                debugPrint(
                                    '[ERROR] Save Profile Error: $error');
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          error.toString())),
                                );
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildLabel(String text, bool isDarkModeValue) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDarkModeValue ? Colors.white : Colors.black,
      ),
    );
  }

  Widget buildInputContainer({
    required TextEditingController controller,
    required double width,
    required double height,
    required String hint,
    required bool isDarkModeValue,
  }) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: isDarkModeValue ? Colors.grey[800] : const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: isDarkModeValue ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: isDarkModeValue ? Colors.white54 : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
