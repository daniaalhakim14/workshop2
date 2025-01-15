import 'package:flutter/material.dart';
import '../../ViewModel/UserModel.dart';
import 'account_page.dart';
import 'insight_page.dart';
import 'notification_page.dart';


class Home extends StatefulWidget {
  final UserModel user; // Accept UserModel as a parameter

  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext homeContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF002B36),
      ),
      body: Center(
        child: Text(
          'Welcome ${widget.user.name}, Your ID: ${widget.user.id}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), // Dark blue
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Home Tab - Active Tab
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home_outlined,
                color: Color(0xFF65ADAD), // Highlighted color for active tab
                size: 30,
              ),
            ),

            // Insight Tab
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  homeContext,
                  MaterialPageRoute(
                    builder: (homeContext) => Insight(user: widget.user), // Pass UserModel
                  ),
                );
              },
              icon: Image.asset(
                'lib/Icons/three lines.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            // Notification Tab
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  homeContext,
                  MaterialPageRoute(
                    builder: (homeContext) => Noti(user: widget.user), // Pass UserModel
                  ),
                );
              },
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            // Account Tab
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  homeContext,
                  MaterialPageRoute(
                    builder: (homeContext) => Account(user: widget.user), // Pass UserModel
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
