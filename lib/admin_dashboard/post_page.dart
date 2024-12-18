import 'package:flutter/material.dart';
import 'package:workshop_2/admin_dashboard/menu_controller.dart'as custom;
import 'package:workshop_2/admin_dashboard/navigation_controller.dart'as nav;
import 'package:workshop_2/admin_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String selectedDate = 'Select Date'; // 默认值

  @override
  Widget build(BuildContext context) {
    custom.MenuController menuController = custom.MenuController.instance;
    List<Map<String, String>> posts = [
      {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Fusce ultrices, ex quis posuere rutrum, nibh nulla porttitor justo',
        'date': '2024-12-15',
        'description': 'Fusce ultrices, ex quis posuere rutrum, nibh nulla porttitor justo, in tempor arcu elit dictum nisl. Nam nisi dolor, posuere et posuere ac, dignissim sed est. Aenean fermentum dapibus pellentesque. Donec eu turpis et enim facilisis egestas. Phasellus felis risus, tincidunt eu feugiat nec, scelerisque non risus. Proin cursus risus accumsan sapien rhoncus sodales. Mauris pharetra egestas fringilla. Mauris quis hendrerit purus. Aliquam vel erat in eros aliquam consectetur et vitae dui. Duis sed dolor nisi. Sed id rutrum mauris. Phasellus auctor non velit nec porta. Mauris ornare at nulla bibendum vulputate. Suspendisse potenti. Suspendisse eros velit, tincidunt ac nulla tempor, maximus posuere odio. Aliquam hendrerit quis justo et pellentesque.Vivamus vestibulum leo ac rhoncus lobortis. Integer ex felis, congue eu nulla eget, auctor egestas quam. Proin libero neque, vestibulum at ornare et, tempor eget lectus. Nulla facilisi. Nullam ac cursus quam. Ut id diam commodo, fermentum mauris eu, iaculis augue. Vivamus gravida volutpat urna, vitae consequat eros. Suspendisse et aliquam turpis. In quis augue aliquet purus semper mattis. Donec suscipit nibh vehicula, ullamcorper odio sed, vehicula eros. Nunc finibus tortor nec laoreet malesuada. Sed hendrerit a leo eu dignissim.Nulla dictum maximus odio, a consectetur metus cursus et. Pellentesque vel justo ut ligula facilisis dapibus sit amet non augue. Nunc porta velit sit amet ipsum pellentesque rhoncus. Cras justo mauris, feugiat pharetra molestie ut, tincidunt a leo. Aenean feugiat lorem eu leo luctus tristique. Vestibulum metus dolor, euismod quis dignissim eu, scelerisque vel neque. Vestibulum pretium enim eros. Maecenas convallis dui vel augue tempus, a faucibus lorem auctor.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut non fringilla est. Sed facilisis ut erat ut lobortis. Mauris vehicula massa ut massa accumsan, et condimentum ipsum gravida. Nulla elementum sodales turpis, eget pretium diam dapibus placerat. Aliquam vel magna enim. Morbi eu orci varius, elementum felis in, mattis magna. Sed id dictum risus. Quisque suscipit sapien lorem, in laoreet tellus tristique in. Duis a mattis enim. Donec vestibulum urna lacus. Quisque fringilla blandit velit, vel pulvinar purus vestibulum et. Duis sed fermentum quam. Cras vulputate faucibus felis quis eleifend. Cras at porttitor ipsum.',
      },
      {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
            {
        'image': 'lib/Icons/default_news_image.png',
        'title': 'Post 2',
        'date': '2024-12-16',
        'description': 'This is the description for Post 2',
      },
      

    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF008080),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'POST',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
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
                      selectedDate,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,  
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return GestureDetector(
                  onTap: () => _showPostDetails(context, post),
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(post['image']!),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(post['title']!,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),  
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
      print("Selected date: $formattedDate");

      setState(() {
        this.selectedDate = formattedDate;
      });
    }
  }

  void _showPostDetails(BuildContext context, Map<String, String> post) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              child: Image.asset(
                post['image']!,
                fit: BoxFit.contain, 
                width: 200,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${post['date']}',
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
                    post['title']!,
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
                            post['description']!,
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
                          _showEditPostDialog(context, post);
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
                          _confirmDelete(context);
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

  void _showEditPostDialog(BuildContext context, Map<String, String> post) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
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
                    child: Image.asset(
                      post['image']!,
                      fit: BoxFit.contain,
                      width: 500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _editImage(post);
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
                          controller: TextEditingController(text: post['title']),
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
                    controller: TextEditingController(text: post['description']),
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
                        onPressed: () {
                          Navigator.of(context).pop();
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
        ),
      ),
    ),
  );
}

void _editImage(Map<String, String> post) async {
  final ImagePicker _picker = ImagePicker();

  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // Update state
    setState(() {
      post['image'] = image.path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image uploaded successfully!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image upload canceled or failed.')),
    );
  }
}


void _uploadImage(Function(String) onImageSelected) async {
  final ImagePicker _picker = ImagePicker();

  try {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      onImageSelected(image.path);
      print('Image uploaded successfully: ${image.path}');
    } else {
      print('Image upload canceled.');
    }
  } catch (e) {
    print('Error picking image: $e');
  }
}

void _showAddPostDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Post',
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
                    child: Image.asset(
                      'lib/Icons/default_news_image.png', 
                      fit: BoxFit.contain,
                      width: 500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //_uploadImage();
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
                          controller: TextEditingController(), 
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
                    controller: TextEditingController(),
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
                        onPressed: () {
                          // Save new post logic
                          Navigator.of(context).pop();
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
        ),
      ),
    ),
  );
}



void _confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this post?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text('No'),
        ),
      ],
    ),
  );
}

}
