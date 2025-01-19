import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_bar_widget/View/Main_pages/homepage.dart';
import '../../admin_dashboard/models/model/notification.dart' as nt;
import '../../admin_dashboard/utils/icon_utils.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../../admin_dashboard/view_model/notification_vm.dart';
import '../Notification_page/notification_details_page.dart';
import 'insight_page.dart';
import 'account_page.dart';

class Noti extends StatefulWidget {
  final UserInfoModule userInfo; // Accept `UserModel` as a parameter
  const Noti({super.key, required this.userInfo});

  @override
  State<Noti> createState() => _NotificationState();
}

class _NotificationState extends State<Noti> {
  
  final NotificationViewModel viewModel = Get.put(NotificationViewModel());
  //final String userID = widget.userInfo.id.toString(); //for testing only, need to integrate with user module
  late String userID;
  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  @override
  void initState() {
    super.initState();
    userID = widget.userInfo.id.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initializeNotifications(userID);
    });
    viewModel.fetchFinancialAidCategories();
  }

  @override
  Widget build(BuildContext notificationContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
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
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF002B36),
                    ),
                  ),
                ],
              );
            })
            ],
          ),
          Obx(() {
            final isExpanded = viewModel.isExpanded.value;

            return Column(
              children: [
                isExpanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    child:Wrap(
  spacing: MediaQuery.of(context).size.width > 600 ? 12.0 : 8.0, //tablet
  runSpacing: MediaQuery.of(context).size.width > 600 ? 12.0 : 8.0, //phone
  alignment: WrapAlignment.start,
  children: viewModel.financialAidCategories.map((category) {
    return SizedBox(

      width: MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width / 4 - 16 // tablet
          : MediaQuery.of(context).size.width / 2 - 16, // phone
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8), 
          getIconForCategory(category['name']),
          const SizedBox(width: 8), 
          Flexible(
            child: Text(
              category['name'],
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12, 
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible, 
            ),
          ),
        ],
      ),
    );
  }).toList(),
)


                  )
                  :const Text(
                    'Icon Navigation',
                    style:  TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),

                      IconButton(
                        icon: Icon(
                          viewModel.isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 24,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          viewModel.isExpanded.toggle(); 
                        },
                      ),


              ],
            );
          }),
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
              return RefreshIndicator(
                onRefresh: () async {
                  refreshNotifications();
                },
                child: ListView.builder(
                  itemCount: viewModel.notifications.length,
                  itemBuilder: (context, index) {
                    nt.Notification notification =  viewModel.notifications[index];
                    Color borderColor;

                    if (notification.type != 'transaction') {
                      borderColor = Colors.green;
                    } else if (notification.type == 'transaction') {
                      borderColor = const Color.fromARGB(255, 216, 110, 110);
                    } else {
                      borderColor = Colors.grey;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: 2.0,),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificatioNDetails(notification: notification),
                              ),
                            );
                          },
                          title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title ?? 'Default Title',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002B36),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: viewModel.fetchCategoriesForNotification(notification.notificationID!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromARGB(255, 220, 220, 220),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return const SizedBox();
                                }
                                final categories = snapshot.data!;
                                return Wrap(
                                  spacing: 4,
                                  children: categories.map((category) {
                                    return getIconForCategory(category['name']);
                                  }).toList(),
                                );
                              },
                            ),
                          ],
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${notification.date ?? 'Unknown Date'} ${notification.time ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                truncateText(notification.description ?? 'No Description', 150),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromARGB(255, 56, 54, 54),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                ),
              );
            }),
          ),
        ],
      ),


      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) =>  HomePage(userInfo: widget.userInfo)),);
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) => Insight(userInfo: widget.userInfo)));
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
                color: const Color(0xFF65ADAD),
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(notificationContext, MaterialPageRoute(builder: (notificationContext) => Account(userInfo: widget.userInfo)));
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

  Future<void> refreshNotifications() async {

    viewModel.isLoading.value = true;
    //await viewModel.initializeNotifications(userID);
    await viewModel.initializeNotifications(userID);
    viewModel.isLoading.value = false;
  }


}
