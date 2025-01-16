import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar_widget/View/Insight_page/transaction_page/subcategory_page.dart';
import 'package:tab_bar_widget/ViewModel/insight_view_model.dart';


class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  NavigatorState? _navigatorState; // Reference to NavigatorState

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save the Navigator reference
    _navigatorState = Navigator.of(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final viewModel = Provider.of<InsightViewModel>(context, listen: false);
      if (!viewModel.fetchingData && viewModel.basicCategories.isEmpty) {
        viewModel.fetchBasicCategory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category Name',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<InsightViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.fetchingData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (viewModel.basicCategories.isEmpty) {
            return const Center(
              child: Text('No Categories available'),
            );
          }

          /*// Print debug information
          for (var category in viewModel.basicCategories) {
            print('Category: ${category.categoryId}, ${category.categoryName}, ${category.iconData}, ${category.iconColor}');
          }*/

          // Precompute category icons and colors
          final Map<String, int> categoryId ={};
          final Map<String, IconData> categoryIcons = {};
          final Map<String, Color> categoryColors = {};

          for (var category in viewModel.basicCategories) {
            if (category.categoryName != null  && category.categoryId != null) {
              if (!categoryIcons.containsKey(category.categoryName)) {
                categoryId[category.categoryName!] = category.categoryId!;
                categoryIcons[category.categoryName!] = category.iconData!;
                categoryColors[category.categoryName!] = category.iconColor!;
              }
            }
          }

          return ListView.builder(
            itemCount: viewModel.basicCategories.length,
            itemBuilder: (context, index) {
              final category = viewModel.basicCategories[index];
              return GestureDetector(
                onTap: () async {
                  print('subcategory page');
                  print('Parent Category ID: ${category}');
                  print('Category name: ${category.categoryName}');
                  // Navigate to the subcategory page and wait for selected subcategory
                  final selectedSubcategory = await Navigator.push(
                  context,
                    MaterialPageRoute(
                        builder: (context) => subcategory_page(
                            parentCategoryId: category.categoryId!,
                            category_name: category.categoryName!,
                    ),
                    )
                  );
                  // Return the selected subcategory data back to the add_transaction page
                  if (selectedSubcategory != null) {
                    _navigatorState?.pop(selectedSubcategory);
                  }
                },
                child: Container(
                  width: 330,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(
                            color: category.iconColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              category.iconData,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            category.categoryName.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
