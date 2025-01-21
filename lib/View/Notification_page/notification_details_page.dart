import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin_dashboard/utils/icon_utils.dart';
import '../../admin_dashboard/view_model/notification_vm.dart';
import '../../admin_dashboard/models/model/notification.dart' as nt;


class NotificatioNDetails extends StatefulWidget {
  final nt.Notification notification;

  const NotificatioNDetails({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NotificatioNDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificatioNDetails> {

  final NotificationViewModel viewModel = Get.put(NotificationViewModel());

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    await viewModel.fetchCategoriesForNotification(widget.notification.notificationID!);
    if (mounted)
    {
      setState(() {});
    }

  }




  @override
  Widget build(BuildContext notificationContext) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  SingleChildScrollView(
          scrollDirection: Axis.horizontal, 
          child: Text(
            widget.notification.title ?? 'Notification Title',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF008080),
        iconTheme: const IconThemeData(
          color: Colors.white, // Sets the back icon color to white
        ),
        /*
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              viewModel.clearCategoryCache(widget.notification.notificationID!);
              await _fetchCategories();
            },
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.notification.image != null)
              Center(
                child: Image.network(
                  widget.notification.image!,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {

                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                  },
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Posted: ${widget.notification.date ?? 'Unknown Date'} ${widget.notification.time ?? ''}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 67, 67, 67),
              ),
            ),
            const SizedBox(height: 10), 
            Text(
              'Type: ${widget.notification.type ?? 'Unknown Type'}', 
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...viewModel.notificationCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          getIconForCategory(category['name']),
                          const SizedBox(width: 4),
                          Text(
                            category['name'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 5),
            Text(
              widget.notification.description ?? 'No Description',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

}
