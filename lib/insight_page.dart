import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'account_page.dart';

class Insight extends StatefulWidget{
  const Insight({super.key});

  @override
  State<Insight> createState() => _InsightState();
}


class _InsightState extends State<Insight>{
  @override
  Widget build(BuildContext insightContext) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), // In Figma color: 002B36
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(insightContext, MaterialPageRoute(builder: (context) => const Home()),);
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
                Navigator.push(insightContext, MaterialPageRoute(builder: (insightContext) => const Noti()));
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
                Navigator.push(insightContext, MaterialPageRoute(builder: (insightContext) => const Account()));
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


