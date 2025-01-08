import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'account_page.dart';
import 'package:workshop_2/admin_dashboard/models/model/notification.dart'as nt;


class NotificatioNDetails extends StatefulWidget {
  final nt.Notification notification;

  const NotificatioNDetails({
    Key? key,
    required this.notification,
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
          widget.notification.title ?? 'Notification Title',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF008080),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.notification.image != null)
              Image.network(
                widget.notification.image!,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            Text(
              'Posted: ${widget.notification.date ?? 'Unknown Date'} ${widget.notification.time ?? ''}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF15BF42),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.notification.description ?? 'No Description',
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
        color: const Color(0xFF002B36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(notificationContext,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(
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
                color: const Color(0xFF65ADAD),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(notificationContext,
                    MaterialPageRoute(builder: (context) => const Noti()));
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
                Navigator.push(notificationContext,
                    MaterialPageRoute(builder: (context) => const Account()));
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
