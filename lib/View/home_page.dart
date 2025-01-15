import 'package:flutter/material.dart';
import 'insight_page.dart';
import 'notification_page.dart';
import 'account_page.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext homeContext) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(  // create the bottom tab
        color: const Color(0xFF002B36), // In Figma color: 002B36
        child: _bottomBarIcons(homeContext),
      ),
    );
  }

  Row _bottomBarIcons(BuildContext homeContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // to ensure equal spacing between icon
      children: <Widget>[

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.home_outlined,
            color: Color(0xFF65ADAD),
            size: 30,
          ),
        ),

        IconButton(
          onPressed: () { // when button press then, navigate to Insight page
            Navigator.push(homeContext, MaterialPageRoute(builder: (homeContext) => const Insight()));
          },
          icon: Image.asset(
            'lib/Icons/three lines.png',
            height: 30,
            width: 30,
            color:Colors.white,
          ),
        ),

        IconButton(
          onPressed: () { // when button press then, navigate to Notification page
            Navigator.push(homeContext, MaterialPageRoute(builder: (homeContext) => const Noti()));
          },
          icon: Image.asset(
            'lib/Icons/notification.png',
            height: 30,
            width: 30,
            color: Colors.white,
          ),
        ),

        IconButton(
          onPressed: () { // when button press then, navigate to account page
            Navigator.push(homeContext, MaterialPageRoute(builder: (homeContext) => const Account()));
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