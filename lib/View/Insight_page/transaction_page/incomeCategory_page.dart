import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ViewModel/insight_view_model.dart';



class incomeCategory_page extends StatefulWidget {

  incomeCategory_page({
    super.key,
});

  @override
  State<incomeCategory_page> createState() => _incomeCategory_pageState();
}

class _incomeCategory_pageState extends State<incomeCategory_page> {
  int _selectedIncomeCategories = -1; // To track the selected subcategory
  NavigatorState? _navigatorState; // Reference to NavigatorState

  @override
  void initState(){
    super.initState();
    // Save the Navigator reference
    _navigatorState = Navigator.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_){
      final viewModel = Provider.of<InsightViewModel>(context, listen: false);
      viewModel.fetchIncomeCategory(); // Always fetch fresh data
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income Category",
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Text('Select an income category',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Consumer<InsightViewModel>(
            builder: (context,viewModel,child){
              if(viewModel.fetchingData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (viewModel.incomeCategories.isEmpty) {
                return const Center(
                  child: Text('No income categories available'),
                );
              }

              // Dynamic List of Subcategories
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.66, // 60% of screen height
                child: ListView.builder(
                  itemCount: viewModel.incomeCategories.length,
                  itemBuilder: (context,index){
                    //print('index: '+index.toString());
                    final incomeCategories = viewModel.incomeCategories[index];
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          if (_selectedIncomeCategories == index) {
                            // Deselect if the same subcategory is tapped again
                            print('Deselected income category');
                            _selectedIncomeCategories = -1;
                          } else if (index < viewModel.incomeCategories.length) {
                            // Ensure index is within range before selecting
                            print('Selected income category');
                            _selectedIncomeCategories = index;
                            print('index: $index');
                          } else {
                            print('Invalid income category index');
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
                                  color: incomeCategories.iconColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 3,
                                  ),
                                ),
                                child: Center(  //Icon
                                  child: Icon(
                                    incomeCategories.iconData, // Dynamic icon
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
                                      incomeCategories.categoryName ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const Spacer(), // Automatically pushes the icon to the far right
                                    Icon(
                                      _selectedIncomeCategories == index
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
                  // Return selected subcategory data
                  final selectedIncome = {
                    'incomeCategoryId': viewModel.incomeCategories[_selectedIncomeCategories].incomecategoryid,
                    'name': viewModel.incomeCategories[_selectedIncomeCategories].categoryName,
                    'icon': viewModel.incomeCategories[_selectedIncomeCategories].iconData,
                    'color': viewModel.incomeCategories[_selectedIncomeCategories].iconColor,
                  };
                  _selectedIncomeCategories = -1; // Reset
                  _navigatorState?.pop(selectedIncome);
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
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white,)
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
