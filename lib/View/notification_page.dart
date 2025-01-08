import 'package:flutter/material.dart';
import 'home_page.dart';
import 'insight_page.dart';
import 'account_page.dart';
import 'package:workshop_2/View/notification_details_page.dart';

class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotificationState();
}

class _NotificationState extends State<Noti> {
  List<Map<String, String>> notifications = [
    {
      'title': 'Aid for Students',
      'datetime': '2024-12-15 10:30 AM',
      'type': 'welfare',
      'details': 'Information included applying and status checking for housewife aid..'
    },
    {
      'title': 'Aid for Housewives',
      'datetime': '2024-12-14 08:00 AM',
      'type': 'welfare',
      'details': 'Information included applying and status checking for housewife aid..'
    },
    {
      'title': 'Transaction Insights',
      'datetime': '2024-12-13 06:00 PM',
      'type': 'transaction',
      'details': 'You spent RM 1,800 last week, 15% less than the previous week. Your was total income...'
    },
    {
      'title': 'Acquiring Support for Disable',
      'datetime': '2024-12-13 06:00 PM',
      'type': 'welfare',
      'details': 'Includes information on assistance/aids provided by the Government to disabled in the country'
    },
  ];

  void deleteAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext notificationContext) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Notification',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF008080),
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete All Notifications',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF002B36),
                ),
              ),
              IconButton(
                onPressed: deleteAllNotifications,
                icon: Icon(
                  Icons.close,
                  color: const Color(0xFF002B36),
                ),
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
                      Color borderColor;

                      if (notification['type'] == 'welfare') {
                        borderColor = Colors.yellow;
                      } else if (notification['type'] == 'transaction') {
                        borderColor = Colors.green;
                      } else {
                        borderColor = Colors.grey; // Default color
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: ListTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                notification['title']!,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002B36),
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Posted: ',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF15BF42),
                                      ),
                                    ),
                                    Text(
                                      notification['datetime']!,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  notification['details']!,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotificatioNDetails(
                                          title: notification['title']!,
                                          datetime: notification['datetime']!,
                                          details: notification['details']!,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                    backgroundColor: const Color(0xFF65ADAD),
                                  ),
                                  child: const Text(
                                    'View Details',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
