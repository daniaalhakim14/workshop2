import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar_widget/Model/InsightPage_model.dart';
import '../../../ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';



class newSubcategory_page extends StatefulWidget {
  final int userid;
  final int? categoryId;
  final int? categoryIconId;
  final Color? iconColor;
  final IconData? iconData;


  newSubcategory_page({
    super.key,
    required this.userid,
    required this.categoryId,
    required this.categoryIconId,
    required this.iconColor,
    required this.iconData,

});

  @override
  State<newSubcategory_page> createState() => _newSubcategory_pageState();
}

class _newSubcategory_pageState extends State<newSubcategory_page> {
  final _textControllerAddNote = TextEditingController(); // to store user input

  @override
  void initState() {
    super.initState();
    // Add listener to the controller
    _textControllerAddNote.addListener(() {
      setState(() {}); // Trigger a rebuild when the text changes
    });
  }

  @override
  void dispose() {
    _textControllerAddNote.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF65ADAD),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black, // Back arrow color
        ),

        title: const Text(
          'New Subcategory',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 14.0),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 18.0, // Adjust the font size as needed
                    color: isDarkMode ? Colors.white : Colors.black, // Adjust color dynamically
                  ),
                ),              ),
            ),
            Row(
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(top: 5.0, bottom: 0.0, left: 14, right: 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 330,
                        height: 48,
                        child: TextField(
                          controller:
                          _textControllerAddNote, // to store user input
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'New subcategory name',
                            suffixIcon: IconButton(
                              onPressed: () {
                                // clear texts in text field
                                _textControllerAddNote.clear();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 0),
                child: Container(
                  width: 330,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding:
                          EdgeInsets.only(top: 15.0, bottom: 0, left: 14.0),
                          child: Text('Preview'),
                        ),
                      ),
                      // Display the icon and the new subcategory name as a preview
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 47,
                                height: 47,
                                decoration: BoxDecoration(
                                  color: widget.iconColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.iconData, // Use the passed icon
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _textControllerAddNote.text.isNotEmpty
                                    ? _textControllerAddNote.text
                                    : '',
                                style: const TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  if (_textControllerAddNote.text.isNotEmpty) {
                    final viewModel = Provider.of<InsightViewModel>(context, listen: false);
                    final newSubcategory = AddSubcategories(
                      userid: widget.userid,
                      newSubcategoryName: _textControllerAddNote.text,
                      parentCategoryId: widget.categoryId,
                      iconId: widget.categoryIconId,
                    );
                    try {
                      await viewModel.addSubcategory(newSubcategory,widget.userid);
                      print("Subcategory added successfully!");
                      Navigator.pop(context,true); // Navigate back on success
                    } catch (e) {
                      print("Failed to add subcategory: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add subcategory: $e")),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    width: 220.0,
                    height: 50.0,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}


