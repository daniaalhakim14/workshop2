import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar_widget/ViewModel/insight_view_model.dart';

import 'newSubcategory_page.dart';

class subcategory_page extends StatefulWidget {

  // Constructor accept category data from category_page
  subcategory_page({
    super.key,
    required this.parentCategoryId,
    required this.category_name,
  });

  final int parentCategoryId; // Add parentCategoryId
  final String category_name;

  @override
  State<subcategory_page> createState() => _subcategory_pageState();
}

class _subcategory_pageState extends State<subcategory_page> {
  int _selectedSubcategory = -1; // To track the selected subcategory
  NavigatorState? _navigatorState; // Reference to NavigatorState

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save the Navigator reference
    _navigatorState = Navigator.of(context);
    final viewModel = Provider.of<InsightViewModel>(context);
    viewModel.addListener(() {
      if (_selectedSubcategory >= viewModel.subcategory.length) {
        // Reset if the selected index is no longer valid
        setState(() {
          _selectedSubcategory = -1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final viewModel = Provider.of<InsightViewModel>(context, listen: false);
      viewModel.fetchSubcategories(widget.parentCategoryId); // Always fetch fresh data
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category_name,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Text('Select a subcategory',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Consumer<InsightViewModel>(
            builder: (context, viewModel,child){
              if(viewModel.fetchingData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (viewModel.subcategory.isEmpty) {
                return const Center(
                  child: Text('No Categories available'),
                );
              }

              // Dynamic List of Subcategories
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.66, // 60% of screen height
                child: ListView.builder(
                    itemCount: viewModel.subcategory.length,
                    itemBuilder: (context,index){
                      //print('index: '+index.toString());
                      final subcategory = viewModel.subcategory[index];
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            if (_selectedSubcategory == index) {
                              // Deselect if the same subcategory is tapped again
                              print('Deselected subcategory');
                              _selectedSubcategory = -1;
                            } else if (index < viewModel.subcategory.length) {
                              // Ensure index is within range before selecting
                              print('Selected subcategory');
                              _selectedSubcategory = index;
                              print('index: $index');
                            } else {
                              print('Invalid subcategory index');
                            }
                          });
                        },
                        child: Container(
                          width: 330,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: 47,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    color: subcategory.iconColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 3,
                                    ),
                                  ),
                                  child: Center(  //Icon
                                    child: Icon(
                                      subcategory.iconData, // Dynamic icon
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Subcategory Name and Selection Indicator
                              Expanded(
                                  child:Row(
                                    children: [
                                      Text(
                                        subcategory.subcategoryName ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const Spacer(), // Automatically pushes the icon to the far right
                                      Icon(
                                        _selectedSubcategory == index
                                            ? Icons.circle
                                            : Icons.circle_outlined,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar:  BottomAppBar(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final viewModel = Provider.of<InsightViewModel>(context, listen: false);

                if (_selectedSubcategory == -1) {
                  // Fetch details for the new subcategory
                  final categoryId = widget.parentCategoryId;
                  final categoryIconId = viewModel.subcategory.isNotEmpty
                      ? viewModel.subcategory.first.iconId
                      : null;
                  final categoryIconColor = viewModel.subcategory.isNotEmpty
                      ? viewModel.subcategory.first.iconColor
                      : Colors.grey;
                  final categoryIconData = viewModel.subcategory.isNotEmpty
                      ? viewModel.subcategory.first.iconData
                      : Icons.error;

                  // Navigate to `newSubcategory_page` and wait for result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => newSubcategory_page(
                        categoryId: categoryId,
                        categoryIconId: categoryIconId,
                        iconColor: categoryIconColor,
                        iconData: categoryIconData,
                      ),
                    ),
                  );

                  // If a new subcategory was added, refresh the list
                  if (result == true) {
                    print("Refreshing subcategory list...");
                    await viewModel.fetchSubcategories(widget.parentCategoryId);
                  }
                } else {
                  // Return selected subcategory data
                  final selectedSubcategory = {
                    'subcategoryId': viewModel.subcategory[_selectedSubcategory].subcategoryId,
                    'name': viewModel.subcategory[_selectedSubcategory].subcategoryName,
                    'icon': viewModel.subcategory[_selectedSubcategory].iconData,
                    'color': viewModel.subcategory[_selectedSubcategory].iconColor,
                  };
                  _selectedSubcategory = -1; // Reset
                  _navigatorState?.pop(selectedSubcategory);
                }
              },

              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  width: 220.0,
                  height: 50.0,
                  child: _selectedSubcategory == -1
                      ? const Text('New Subcategory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white,),)
                      : const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
