import 'package:flutter/material.dart';
import '../../ViewModel/UserModel.dart';
import '../Main_pages/account_page.dart';
import '../Main_pages/home_page.dart';
import '../Main_pages/notification_page.dart';


class NotificationDetails extends StatefulWidget {
  final String title;
  final String datetime;
  final String details;
  final UserModel user; // Accept UserModel as a parameter

  const NotificationDetails({
    super.key,
    required this.title,
    required this.datetime,
    required this.details,
    required this.user, // Include UserModel in the constructor
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
                    builder: (context) => Home(user: widget.user), // Pass UserModel dynamically
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
                    builder: (context) => Noti(user: widget.user), // Pass UserModel dynamically
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
                    builder: (context) => Account(user: widget.user), // Pass UserModel dynamically
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
