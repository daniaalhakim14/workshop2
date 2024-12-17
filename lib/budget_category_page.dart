import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetCategory extends StatefulWidget{
  const BudgetCategory({super.key});

  @override
  State<BudgetCategory> createState() => _BudgetCategoryState();
}

class _BudgetCategoryState extends State<BudgetCategory> {
  List<String> categories = List.generate(10, (index) => "Category ${index + 1}");
  List<bool> selectedCategories = List.generate(10, (index) => false);
  bool selectAll = false;

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedCategories = List.generate(categories.length, (_) => selectAll);
    });
  }

  void toggleSelectCategory(int index, bool? value) {
    setState(() {
      selectedCategories[index] = value ?? false;
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
      body: Column(
        children: [
          // "Select All" checkbox
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Select All'),
                const Spacer(),
                Checkbox(
                  value: selectAll,
                  onChanged: toggleSelectAll,
                ),
              ],
            ),
          ),

          // Category List as a Widget
          Expanded(
            child: CategoryList(
              categories: categories,
              selectedCategories: selectedCategories,
              onCategoryToggle: toggleSelectCategory,
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
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<String> categories;
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
          title: Text(categories[index]),
          trailing: Radio<bool>(
            value: true,
            groupValue: selectedCategories[index],
            onChanged: (value) {
              onCategoryToggle(index, value);
            },
          ),
        );
      },
    );
  }
}