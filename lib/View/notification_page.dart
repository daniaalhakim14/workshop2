import 'package:flutter/material.dart';
import 'home_page.dart';
import 'insight_page.dart';
import 'account_page.dart';

class Noti extends StatefulWidget{
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotificationState();
}

class _NotificationState extends State<Noti>{
  @override
  Widget build(BuildContext notificationContext) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), // In Figma color: 002B36
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) => const Home()),);
              },
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) => const Insight()));
              },
              icon: Image.asset(
                'lib/Icons/three lines.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: Color(0xFF65ADAD),
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) => const Account()));
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


