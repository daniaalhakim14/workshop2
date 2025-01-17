import 'package:flutter/material.dart';
import 'package:tab_bar_widget/View/Main_pages/homepage.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../Notification_page/notification_details_page.dart';
import 'account_page.dart';
import 'insight_page.dart';


class Noti extends StatefulWidget {
  final UserInfoModule userInfo; // Accept `UserModel` as a parameter

  const Noti({super.key, required this.userInfo});

  @override
  State<Noti> createState() => _NotificationState();
}

class _NotificationState extends State<Noti> {
  List<Map<String, String>> notifications = [
    {
      'title': 'Aid for Students',
      'datetime': '2024-12-15 10:30 AM',
      'type': 'welfare',
      'details': 'Information included applying and status checking for student aid...',
    },
    {
      'title': 'Aid for Housewives',
      'datetime': '2024-12-14 08:00 AM',
      'type': 'welfare',
      'details': 'Information included applying and status checking for housewife aid...',
    },
    {
      'title': 'Transaction Insights',
      'datetime': '2024-12-13 06:00 PM',
      'type': 'transaction',
      'details': 'You spent RM 1,800 last week, 15% less than the previous week...',
    },
    {
      'title': 'Support for Disabled',
      'datetime': '2024-12-13 06:00 PM',
      'type': 'welfare',
      'details': 'Includes information on assistance provided to disabled individuals...',
    },
  ];

  void deleteAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF008080),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Delete All Notifications',
                  style: TextStyle(fontSize: 14, color: Color(0xFF002B36)),
                ),
              ),
              IconButton(
                onPressed: deleteAllNotifications,
                icon: const Icon(Icons.delete, color: Color(0xFF002B36)),
              ),
            ],
          ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(
              child: Text(
                'No Notifications',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final borderColor = notification['type'] == 'welfare'
                    ? Colors.yellow
                    : notification['type'] == 'transaction'
                    ? Colors.green
                    : Colors.grey;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: ListTile(
                      title: Text(
                        notification['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002B36),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Posted: ${notification['datetime']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            notification['details']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationDetails(
                                    title: notification['title']!,
                                    datetime: notification['datetime']!,
                                    details: notification['details']!,
                                    userInfo: widget.userInfo, // Pass UserModel
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF65ADAD),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(userInfo: widget.userInfo), // Pass UserModel
                  ),
                );
              },
              icon: const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Insight(userInfo: widget.userInfo), // Pass UserModel
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
            IconButton(
              onPressed: () {}, // Current page
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: const Color(0xFF65ADAD), // Highlight active tab
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Account(userInfo: widget.userInfo), // Pass UserModel
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
