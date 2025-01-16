import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Model/Category.dart';
import '../../../ViewModel/CategoryViewModel.dart';

class BudgetChoosingCategory extends StatefulWidget{
  const BudgetChoosingCategory({super.key});

  @override
  State<BudgetChoosingCategory> createState() => _BudgetCategoryState();
}

class _BudgetCategoryState extends State<BudgetChoosingCategory> {

  @override
  void initState() {
    super.initState();
    // Fetch budget data when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Consumer<CategoryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          return Column(
            children: [
              // "Select All" checkbox
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text('Select All'),
                    const Spacer(),
                    Checkbox(
                      value: viewModel.selectAll,
                      onChanged: (value) => viewModel.toggleSelectAll(value),
                    ),
                  ],
                ),
              ),

              // Category List as a Widget
              Expanded(
                child: CategoryList(
                  categories: viewModel.categories,
                  selectedCategories: viewModel.selectedCategories,
                  onCategoryToggle: viewModel.toggleSelectCategory,
                ),
              ),

              // Done button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      // Action when Done is clicked
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final List<bool> selectedCategories;
  final Function(int, bool?) onCategoryToggle;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategoryToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          leading: Icon(
            Icons.category, // Replace this with the desired icon
            color: Colors.blue, // Customize the icon color
            size: 24.0, // Customize the icon size
          ),
          title: Text(categories[index].name),
          trailing: Checkbox(
            value: selectedCategories[index],
            onChanged: (bool? value) {
              onCategoryToggle(index, value);
            },
          ),
        );
      },
    );
  }
}