import 'package:flutter/material.dart';
import 'home_page.dart';
import 'insight_page.dart';
import 'notification_page.dart';

class Account extends StatefulWidget{
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), // In Figma color: 002B36
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()),);
              },
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Insight()));
              },
              icon: Image.asset(
                'lib/Icons/three lines.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Noti()));
              },
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'lib/Icons/safe.png',
                height: 30,
                width: 30,
                color:Color(0xFF65ADAD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


