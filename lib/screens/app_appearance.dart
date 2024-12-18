import 'package:flutter/material.dart';

class AppAppearance extends StatefulWidget {
  const AppAppearance({super.key});

  @override
  State<AppAppearance> createState() => _AppAppearanceState();
}

class _AppAppearanceState extends State<AppAppearance> {
  bool isDarkMode = false;
  bool matchWithSystem = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'App appearance',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppearanceOption(
              title: 'Switch to dark mode',
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildAppearanceOption(
              title: 'Match with the system',
              value: matchWithSystem,
              onChanged: (bool value) {
                setState(() {
                  matchWithSystem = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAppearanceOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Switch(
          value: value,
          activeColor: Colors.white,

          inactiveThumbColor: Colors.black,

          activeTrackColor: Colors.black,

          inactiveTrackColor: Colors.white,
          onChanged: onChanged,
        ),
      ],
    );
  }
}