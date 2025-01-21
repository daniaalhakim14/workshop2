import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
//import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../../models/model/notification.dart' as nt;
import '../../models/services/cloudinary_service.dart';
import '../../utils/icon_utils.dart';
import '../../utils/message_util.dart';
import '../../view_model/notification_vm.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key}); 
  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final NotificationViewModel viewModel = Get.put(NotificationViewModel());
  final CloudinaryService cloudinaryService = CloudinaryService();
  String? _selectedDate;
  //html.File? _selectedImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    // fetch data
    viewModel.fetchNotifications();
    viewModel.fetchFinancialAidCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008080),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.black, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          _selectedDate ?? 'Select Date',
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () async {
                    setState(() {
                      _selectedDate = null; 
                    });
                    viewModel.updateSelectedDate(''); 
                    await viewModel.fetchNotificationsByDate(null); 
                  },
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _showAddPostDialog(context)
                ),
                const Text(
                  'NEW',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0), 
        child:Obx(() {
          if (viewModel.notifications.isEmpty) {
            if (viewModel.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(child: Text('No Notifications'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                fit: BoxFit.contain,
                                height: 150,
                                width: 150,
                              )
                            : const Icon(Icons.image_not_supported, size: 100),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  notification.title ?? 'Default Title',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FutureBuilder<List<Map<String, dynamic>>> (
                                future: viewModel.fetchCategoriesForNotification(
                                    notification.notificationID!),
                                builder: (context, snapshot) {
                                  
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 220, 220, 220)),
                                        ),
                                    );
                                  }
                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return const Text(
                                      'No category',
                                      style: TextStyle(fontSize: 12),
                                    );
                                  }
                                  final categories = snapshot.data!;
                                  return Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    children: categories.map((category) {
                                      return Column(
                                        children: [
                                          getIconForCategory(category['name']),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
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
      )
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

      if (!mounted) return; //
      setState(() {
        _selectedDate = formattedDate; 
      });

      viewModel.updateSelectedDate(formattedDate);
      await viewModel.fetchNotificationsByDate(formattedDate);
    }
  }

void _showNotificationDetails(BuildContext context, nt.Notification notification) async {
  await viewModel.fetchCategoriesForNotification(notification.notificationID!);
  if (!mounted) return; //
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              child: notification.image != null
                  ? Image.network(
                      notification.image!,
                      fit: BoxFit.contain,
                      height: 800,
                      width: 800,
                    )
                  : const Icon(Icons.image_not_supported, size: 100),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${notification.date ?? 'Unknown Date'} ${notification.time ?? ''}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    notification.title ?? 'Default Title',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          'Type: ${notification.type}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
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
                        ],)),
                        const SizedBox(height: 20),
                        const Divider(),
                        Text(
                          notification.description ?? 'No description',
                          style: const TextStyle(
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showEditPostDialog(context, notification);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF008080),
                        ),
                        child: const Text(
                          'EDIT',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      TextButton(
                        onPressed: () {
                          _confirmDelete(context, notification.notificationID.toString());
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF008080),
                        ),
                        child: const Text(
                          'DELETE',
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  void _showEditPostDialog(BuildContext context, nt.Notification notification) async {
    imageUrl = notification.image;
    final TextEditingController titleController = TextEditingController(text: notification.title);
    final TextEditingController descriptionController = TextEditingController(text: notification.description);
    
    await viewModel.fetchCategoriesForNotification(notification.notificationID!);

    //List<int> selectedCategories = notification.financialAidCategoryIDs ?? [];
    final selectedCategories = <int>[].obs;
    String selectedType = notification.type ?? 'Welfare';  // Default to 'welfare' if null

    selectedCategories.assignAll(
      viewModel.notificationCategories
          .map((category) => category['financialaidcategoryid'] as int)
          .toList(),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) 
          {
                return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
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
                      const SizedBox(height: 16),
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
                              imageUrl = uploadedImageUrl; 
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
                          backgroundColor: const Color(0xFF008080),
                        ),
                        child: const Text(
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
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        value: selectedType,
                        hint: const Text("Select Financial Aid Type"),
                        items: const [
                          DropdownMenuItem(value: 'Welfare', child: Text('Welfare')),
                          DropdownMenuItem(value: 'Subsidy', child: Text('Subsidy')),
                          DropdownMenuItem(value: 'Tax Relief', child: Text('Tax Relief')),
                          DropdownMenuItem(value: 'Tips', child: Text('Tips')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                          value: selectedCategories.isNotEmpty ? selectedCategories.first : null,
                          hint: const Text("Select Categories"),
                          items: viewModel.financialAidCategories
                              .map((category) => DropdownMenuItem<int>(
                                    value: category['financialaidcategoryid'],
                                    child: Text(category['name']),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                                  if (value != null) {
                                    if (selectedCategories.length >= 4) {
                                      MessageUtils.showMessage(
                                        context: context,
                                        title: "Limit Reached",
                                        description: "You can only select up to 4 categories.",
                                      );
                                    } else if (!selectedCategories.contains(value)) {
                                      selectedCategories.add(value);
                                    }
                                  }
                                });
                          },
                        );
                      }),
                      Wrap(
                        children: selectedCategories
                          .map((categoryId) => Chip(
                            label: Text(
                              viewModel.financialAidCategories
                                  .firstWhere((c) => c['financialaidcategoryid'] == categoryId)['name'],
                            ),
                            onDeleted: () {
                              setState(() {
                                selectedCategories.remove(categoryId);
                              });
                            },
                          )).toList(),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: descriptionController,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: titleController.text.isEmpty || descriptionController.text.isEmpty 
                                ? null
                                : () async {

                                    final updatedNotification = nt.Notification(
                                      notificationID: notification.notificationID,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      image: imageUrl,
                                      type: selectedType,
                                      financialAidCategoryIDs: selectedCategories,
                                      adminID: notification.adminID,
                                      date: notification.date,
                                      time: notification.time,
                                    );

                                    final isNotificationUpdated = await viewModel.updateNotificationDetailsWithMessage(
                                      updatedNotification,
                                      titleController.text,
                                      descriptionController.text,
                                      imageUrl,
                                    );

                                    if (isNotificationUpdated) {
                                      await viewModel.updateNotificationCategories(
                                        notification.notificationID!,
                                        selectedCategories,
                                      );
                                    }
                                    
                                  },
                            style: TextButton.styleFrom(
                              backgroundColor: titleController.text.isEmpty || descriptionController.text.isEmpty
                                  ? Colors.grey
                                  : const Color(0xFF008080),
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 225, 77, 66),
                            ),
                            child: const Text(
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
                      const SizedBox(height: 16),
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

  String? selectedType;

  setState(() {
    imageUrl = null;
    selectedType = 'Welfare';
  });

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  //final TextEditingController typeController = TextEditingController();
  Uint8List? imageBytes;

  final selectedCategories = <int>[].obs;
  viewModel.fetchFinancialAidCategories();

  final box = GetStorage();
  int? adminID = box.read('adminData')['adminid'];

   showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
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
                      const SizedBox(height: 16),
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
                          } else {
                            MessageUtils.showMessage(
                              context: context,
                              title: "Error",
                              description: "Failed to upload image.",
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF008080),
                        ),
                        child: const Text(
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
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0), 
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFF008080), width: 2.0), 
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        hint: const Text("Select Financial Aid Type",style: TextStyle(color: Colors.grey,),),
                        value: selectedType,
                        items: const [
                          DropdownMenuItem(
                            value: 'Welfare',
                            child: Text('Welfare'),
                          ),
                          DropdownMenuItem(
                            value: 'Subsidy',
                            child: Text('Subsidy'),
                          ),
                          DropdownMenuItem(
                            value: 'Tax relief',
                            child: Text('Tax Relief'),
                          ),
                          DropdownMenuItem(
                            value: 'Tips', 
                            child: Text('Tips')
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Color(0xFF008080), width: 2.0),
                            ),
                          ),
                          value: null,
                          hint: const Text("Select Categories",style: TextStyle(color: Colors.grey,),),
                          items: viewModel.financialAidCategories
                              .map((category) => DropdownMenuItem<int>(
                                    value: category['financialaidcategoryid'],
                                    child: Text(
                                      category['name'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null && selectedCategories.length < 4) {
                              setState(() {
                                if (!selectedCategories.contains(value)) {
                                  selectedCategories.add(value);
                                }
                              });
                            } else if (selectedCategories.length >= 4) {
                              MessageUtils.showMessage(
                                context: context,
                                title: "Limit Reached",
                                description: "You can only select up to 4 categories.",
                              );
                            }
                          },
                        );

                      }),
                      Wrap(
                        children: selectedCategories
                            .map((categoryId) => Chip(
                                  label: Text(
                                    viewModel.financialAidCategories
                                        .firstWhere((c) =>
                                            c['financialaidcategoryid'] ==
                                            categoryId)['name'],
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      selectedCategories.remove(categoryId);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: descriptionController,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final title = titleController.text;
                              final description = descriptionController.text;

                              await viewModel.addNotificationWithMessage(
                                title: title,
                                description: description,
                                type: selectedType!,
                                imageUrl: imageUrl,
                                adminID: adminID,
                                financialAidCategoryIDs: selectedCategories,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:  const Color(0xFF008080),
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 225, 77, 66),
                            ),
                            child: const Text(
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
                      const SizedBox(height: 16),
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
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this post?'),
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
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              navigator.pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }



}


