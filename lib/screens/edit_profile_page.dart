import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              buildLabel('Full Name'),
              buildInputContainer(width: 351, height: 62, hint: 'Insert New Name'),
              const SizedBox(height: 20),

              buildLabel('Address'),
              buildInputContainer(width: 351, height: 122, hint: 'Insert Address'),
              const SizedBox(height: 20),

              buildLabel('Phone Number'),
              buildInputContainer(width: 351, height: 62, hint: 'Insert Phone Number'),
              const SizedBox(height: 20),

              buildLabel('Email'),
              buildInputContainer(width: 351, height: 62, hint: 'Insert Email'),
              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: 265,
                  height: 53,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal,
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
  }


  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }


  Widget buildInputContainer({
    required double width,
    required double height,
    required String hint,
  }) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
