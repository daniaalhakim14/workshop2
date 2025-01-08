import 'dart:convert';
//import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workshop_2/admin_dashboard/controllers/menu_controller.dart'as custom;
import 'package:workshop_2/admin_dashboard/controllers/navigation_controller.dart'as nav;
import 'package:workshop_2/admin_dashboard/view/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workshop_2/admin_dashboard/view_model/notification_vm.dart';
import 'package:workshop_2/admin_dashboard/models/model/notification.dart' as nt;
import 'package:image/image.dart'as img;
import 'package:workshop_2/admin_dashboard/models/services/cloudinary_service.dart';
import 'package:workshop_2/admin_dashboard/utils/message_util.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final NotificationViewModel viewModel = Get.put(NotificationViewModel());
  final CloudinaryService cloudinaryService = CloudinaryService();
  String? _selectedDate;
  html.File? _selectedImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    // fetch data
    viewModel.fetchNotifications();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF008080),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'NOTIFICATION',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range, color: Colors.black, size: 16),
                        SizedBox(width: 10),
                        Text(
                          _selectedDate ?? 'Select Date',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.white),
                  onPressed: () async {
                    setState(() {
                      _selectedDate = null; // Clear the selected date
                    });
                    viewModel.updateSelectedDate(''); // Clear the date in ViewModel
                    await viewModel.fetchNotificationsByDate(null); // Fetch all notifications
                  },
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => _showAddPostDialog(context)
                ),
                Text(
                  'NEW',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (viewModel.notifications.isEmpty) {
          return Center(child: Text('No Notifications'));
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: viewModel.notifications.length,
          itemBuilder: (context, index) {
            nt.Notification notification = viewModel.notifications[index];
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: () => _showNotificationDetails(context, notification),
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: notification.image != null
                          ? Image.network(
                              notification.image!,
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            )
                          : const Icon(Icons.image_not_supported, size: 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          notification.title ?? 'Default Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            );

          },
        );
      }),
    );
  }
  
Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];

      setState(() {
        _selectedDate = formattedDate; 
      });

      viewModel.updateSelectedDate(formattedDate);
      await viewModel.fetchNotificationsByDate(formattedDate);
    }
  }

void _showNotificationDetails(BuildContext context, nt.Notification notification) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              child:  notification.image != null
                ? Image.network(
                    notification.image!,
                    fit: BoxFit.contain,
                    height: 800,
                    width: 800,
                  )
                : const Icon(Icons.image_not_supported, size: 100),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${notification.date ?? 'Unknown Date'} ${notification.time ?? ''}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                      ),
                  ],),
                  SizedBox(height: 20),
                  Text(
                    notification.title ?? 'Default Title',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                  )),
                  SizedBox(height: 30),
                  Expanded(
                    child: SizedBox(
                      height: 400,
                      child: ListView(
                        children: [
                          Text(
                            notification.description ?? 'No description',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  //Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showEditPostDialog(context, notification);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF008080),
                        ),
                        child: Text(
                          'EDIT', 
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        ),
                      ),
                      SizedBox(width: 30),

                      TextButton(
                        onPressed: () {
                          _confirmDelete(context,notification.notificationID.toString());
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF008080),
                        ),
                        child: Text(
                          'DELETE', 
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
            ),),


          ],
        ),
      ),
    ),
  );
}

  void _showEditPostDialog(BuildContext context, nt.Notification notification) {
    imageUrl = notification.image;
    final TextEditingController titleController = TextEditingController(text: notification.title);
    final TextEditingController descriptionController = TextEditingController(text: notification.description);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) 
          {
                return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit Post',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: imageUrl != null
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.contain,
                            height: 800,
                            width: 800,
                          )
                        : const Icon(Icons.image_not_supported, size: 100),
                      ),
                      TextButton(
                        onPressed: () async {
                          final uploadedImageUrl = await cloudinaryService.uploadImage();
                          if (uploadedImageUrl != null) {
                            setState(() {
                              imageUrl = uploadedImageUrl; // 更新图片 URL
                            });
                            MessageUtils.showMessage(
                              context: context,
                              title: "Success",
                              description: "Image upladed successfully.",
                            );
                            print("Image uploaded successfully: $uploadedImageUrl");
                          } else {
                            MessageUtils.showMessage(
                              context: context,
                              title: "Error",
                              description: "Failed to upload image.",
                            );
                            print("Failed to upload image");
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF008080),
                        ),
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: descriptionController,
                        maxLines: 17,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 30),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {

                              final title = titleController.text.trim();
                              final description = descriptionController.text.trim();
                              final box = GetStorage();
                              int? adminID = box.read('adminData')['adminid'];

                              if (title.isNotEmpty && description.isNotEmpty) 
                              {
                                notification.title = title;
                                notification.description = description;
                                notification.image = imageUrl;

                                final isUpdated = await viewModel.updateNotification(notification.notificationID.toString(),notification);
                                if (isUpdated) {
                                  setState(() {
                                    notification.title = title; 
                                    notification.description = description; 
                                    notification.image = imageUrl; 
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  MessageUtils.showMessage(
                                    context: context,
                                    title: "Success",
                                    description: "Notification updated successfully.",
                                  );
                                } else {
                                  MessageUtils.showMessage(
                                    context: context,
                                    title: "Error",
                                    description: "Failed to update notification.",
                                  );
                                }
                              }else {
                                  MessageUtils.showMessage(
                                    context: context,
                                    title: "Error",
                                    description: "Title and Description cannot be empty.",
                                  );
                                }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF008080),
                            ),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 225, 77, 66),
                            ),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          
          },
    
        ),
      ),
    )
    );
  }

void _showAddPostDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  Uint8List? imageBytes;

  final box = GetStorage();
  int? adminID = box.read('adminData')['adminid'];

   showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Add Notification',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: imageBytes != null
                            ? Image.memory(
                                imageBytes, 
                                fit: BoxFit.contain,
                                width: 500,
                              )
                            : imageUrl != null
                                ? Image.network(
                                    imageUrl!, 
                                    fit: BoxFit.contain,
                                    width: 500,
                                  )
                                : Image.asset(
                                    'lib/Icons/default_news_image.png', 
                                    fit: BoxFit.contain,
                                    width: 500,
                                  ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final uploadedImageUrl = await cloudinaryService.uploadImage();
                          if (uploadedImageUrl != null) {
                            setState(() {
                              imageUrl = uploadedImageUrl; 
                            });
                            MessageUtils.showMessage(
                              context: context,
                              title: "Success",
                              description: "Image uploaded successfully.",
                            );
                            print("Image uploaded successfully: $uploadedImageUrl");
                          } else {
                            MessageUtils.showMessage(
                              context: context,
                              title: "Error",
                              description: "Failed to upload image.",
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF008080),
                        ),
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: descriptionController,
                        maxLines: 17,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final title = titleController.text;
                              final description = descriptionController.text;
                              final type = 'welfare';

                              if (title.isNotEmpty &&
                                  description.isNotEmpty &&
                                  type.isNotEmpty &&
                                  adminID != null) {
                                final notification = nt.Notification(
                                  notificationID: null,
                                  title: title,
                                  type: type,
                                  description: description,
                                  image: imageUrl,
                                  adminID: adminID,
                                  date: DateTime.now().toString().split(' ')[0],
                                  time: DateTime.now()
                                      .toLocal()
                                      .toString()
                                      .split(' ')[1],
                                );

                                final isSuccess = await viewModel.addNotification(notification);

                                if (isSuccess) {
                                  Navigator.of(context).pop();
                                  MessageUtils.showMessage(
                                    context: context,
                                    title: "Success",
                                    description: "Notification added successfully.",
                                  );
                                } else {
                                  MessageUtils.showMessage(
                                    context: context,
                                    title: "Error",
                                    description: "Failed to add notification.",
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please fill in all fields or log in as admin')),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF008080),
                            ),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 225, 77, 66),
                            ),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}





  void _confirmDelete(BuildContext context, String notificationID) {

    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () async {
              final isDeleted = await viewModel.deleteNotification(notificationID);
              navigator.pop();
              navigator.pop();
              if (isDeleted) {
                MessageUtils.showMessage(
                  context: context,
                  title: "Success",
                  description: "Notification deleted successfully.",
                );
              } else {
                MessageUtils.showMessage(
                  context: context,
                  title: "Error",
                  description: "Failed to delete the notification.",
                );
              }
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              navigator.pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }



}


