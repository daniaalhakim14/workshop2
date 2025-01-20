import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Model/Category.dart';

class CategoryViewModel extends ChangeNotifier {
  List<Category> _categories = [];
  List<bool> _selectedCategories = [];
  bool _selectAll = false;
  bool _isLoading = true;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<bool> get selectedCategories => _selectedCategories;
  bool get selectAll => _selectAll;

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.get(Uri.parse('http://10.131.75.179:3000/category'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> categoryList = jsonResponse['category'];
        _categories = categoryList.map((json) => Category.fromJson(json)).toList();
        _selectedCategories = List.generate(_categories.length, (_) => false);
        _error = null;
      } else {
        _error = 'Failed to load categories: ${response.statusCode}';
        _categories = [];
      }
    } catch (e) {
      _error = 'Error fetching categories: $e';
      print('Error fetching categories: $e');
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelectAll(bool? value) {
    _selectAll = value ?? false;
    _selectedCategories = List.generate(_categories.length, (_) => _selectAll);
    notifyListeners();
  }

  void toggleSelectCategory(int index, bool? value) {
    if (index < _selectedCategories.length) {
      _selectedCategories[index] = value ?? false;

      // Update selectAll based on if all categories are selected
      _selectAll = _selectedCategories.every((isSelected) => isSelected);
      notifyListeners();
    }
  }

  // Method to get selected category names
  List<String> getSelectedCategoryNames() {
    List<String> selectedNames = [];
    for (int i = 0; i < categories.length; i++) {
      if (selectedCategories[i]) {
        selectedNames.add(categories[i].name);
      }
    }
    return selectedNames;
  }

  List<Category> getSelectedCategory() {
    List<Category> selectedCategory = [];
    for (int i = 0; i < categories.length; i++) {
      if (selectedCategories[i]) {
        selectedCategory.add(categories[i]);
      }
    }
    return selectedCategory;
  }
}