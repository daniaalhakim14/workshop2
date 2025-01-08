import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:workshop_2/admin_dashboard/models/model/notification.dart'as nt;
import 'package:workshop_2/admin_dashboard/view_model/notification_vm.dart';
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
  
  final NotificationViewModel viewModel = Get.put(NotificationViewModel());
  final String userID = '10'; //for testing only, need to integrate with user module

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  @override
  void initState() {
    super.initState();

    viewModel.initializeNotifications(userID);
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
        backgroundColor: const Color(0xFF65ADAD), //0xFF008080
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      viewModel.isDescending.value ? Icons.arrow_downward : Icons.arrow_upward,
                    ),
                    onPressed: () {
                      viewModel.toggleSortOrder();
                    },
                  ),
                  Text(
                    viewModel.isDescending.value ? 'Newer to Older  ' : 'Older to Newer  ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: const Color(0xFF002B36),
                    ),
                  ),
                ],
              );
            })
            ],
          ),
          Expanded(
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (viewModel.notifications.isEmpty) {
                return const Center(
                  child: Text(
                    'No Notifications',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: viewModel.notifications.length,
                itemBuilder: (context, index) {
                  nt.Notification notification = viewModel.notifications[index];
                  Color borderColor;

                  if (notification.type == 'welfare') {
                    borderColor = Colors.yellow;
                  } else if (notification.type == 'transaction') {
                    borderColor = Colors.green;
                  } else {
                    borderColor = Colors.grey;
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
                            notification.title ?? 'Default Title',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002B36),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Posted: ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF15BF42),
                                  ),
                                ),
                                Text(
                                  '${notification.date ?? 'Unknown Date'} ${notification.time ?? ''}',
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
                              truncateText(notification.description ?? 'No Description', 30),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(255, 56, 54, 54),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificatioNDetails(notification: notification),
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
              );
            }),
          )

        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), 
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
