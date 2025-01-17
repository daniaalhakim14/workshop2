import 'package:flutter/material.dart';
import 'package:tab_bar_widget/View/Main_pages/homepage.dart';
import '../../Model/SignupLoginPage_model.dart';

import '../Main_pages/account_page.dart';
import '../Main_pages/notification_page.dart';


class NotificationDetails extends StatefulWidget {
  final String title;
  final String datetime;
  final String details;
  final UserInfoModule userInfo; // Accept UserModel as a parameter

  const NotificationDetails({
    super.key,
    required this.title,
    required this.datetime,
    required this.details,
    required this.userInfo, // Include UserModel in the constructor
  });

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext notificationContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF008080),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posted: ${widget.datetime}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF15BF42),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.details,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), // In Figma color: 002B36
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  notificationContext,
                  MaterialPageRoute(
                    builder: (context) => HomePage(userInfo: widget.userInfo), // Pass UserModel dynamically
                  ),
                );
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  notificationContext,
                  MaterialPageRoute(
                    builder: (context) => Noti(userInfo: widget.userInfo), // Pass UserModel dynamically
                  ),
                );
              },
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: const Color(0xFF65ADAD), // Active tab highlight
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  notificationContext,
                  MaterialPageRoute(
                    builder: (context) => Account(userInfo: widget.userInfo), // Pass UserModel dynamically
                  ),
                );
              },
              icon: Image.asset(
                'lib/Icons/safe.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
