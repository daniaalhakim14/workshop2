import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'account_page.dart';

class NotificatioNDetails extends StatefulWidget {
  final String title;
  final String datetime;
  final String details;

  const NotificatioNDetails({
    Key? key,
    required this.title,
    required this.datetime,
    required this.details,
  }) : super(key: key);

  @override
  State<NotificatioNDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificatioNDetails> {

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
                Navigator.push(notificationContext, MaterialPageRoute(builder: (context) => const Home()),);
              },
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'lib/Icons/three lines.png',
                height: 30,
                width: 30,
                color: Color(0xFF65ADAD),
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (context) => const Noti()));
              },
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (context) => const Account()));
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
