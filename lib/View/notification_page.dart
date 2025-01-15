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
        child: _bottomBarIcons(notificationContext),
      ),
    );
  }

  // Refactor version. (the bottom icons syntax for notification)
  Row _bottomBarIcons(BuildContext notificationContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () { // when button press then, navigate to Home page
            Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) => const Home()),);
          },
          icon: Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),

        IconButton(
          onPressed: () { // when button press then, navigate to Insight page
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
          onPressed: () { // when button press then, navigate to Account page
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
    );
  }
}