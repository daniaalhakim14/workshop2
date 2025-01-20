//The repository centralizes all data-fetching and data-processing
// logic in one place

import 'dart:convert';
import '../../Model/InsightPage_model.dart';
import 'InsightPage_Calling_API.dart';

class InsightRepository{
  final CallingApi _service = CallingApi();

  Future<List<TransactionsExpense>> getTransactionsExpense() async {
    final response = await _service.fetchTransactionsExpense();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // This is a list of maps
      print('Decoded Transaction Expense: $data'); // Debugging log
      return List<TransactionsExpense>.from(
          data.map((x) => TransactionsExpense.fromJson(x)) // Map each item
      );
    } else {
      throw Exception('Failed to load Transaction Expense');
    }
  }

  Future<List<TransactionList>> getTransactionList() async {
    final response = await _service.fetchTransactionList();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // This is a list of maps
      print('Decoded Transaction List: $data'); // Debugging log
      return List<TransactionList>.from(
          data.map((x) => TransactionList.fromJson(x)) // Map each item
      );
    } else {
      throw Exception('Failed to load Transaction List');
    }
  }

  Future<List<BasicCategories>> getBasicCategories() async {
    final response = await _service.fetchBasicCategories();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //print('Decoded Basic Categories: $data');
      return List<BasicCategories>.from(
          data.map((x) => BasicCategories.fromJson(x))
      );
    } else {
      print('API Error: ${response.body}');
      throw Exception('Failed to load Basic Categories');
    }
  }

  Future<List<IncomeCategories>> getIncomeCategories() async {
    final response = await _service.fetchIncomeCategories();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded Income Categories: $data');
      return List<IncomeCategories>.from(
          data.map((x) => IncomeCategories.fromJson(x))
      );
    } else {
      print('API Error: ${response.body}');
      throw Exception('Failed to load Basic Categories');
    }
  }

  Future<List<Subcategories>> getSubcategories(int parentCategoryId) async {
    final response = await _service.fetchSubcategories(parentCategoryId);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //print('Decoded subcategories: $data');
      return List<Subcategories>.from(
        data.map((x) => Subcategories.fromJson(x))
      );
    } else {
      print('API Error: ${response.body}');
      throw Exception('Failed to load subcategories');
    }
  }

  Future<void> addIcon(AddIcon icon) async {
    final response = await _service.addIcon(icon.toMap());

    // Log the response for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to add icon to database: ${response.body}');
    }
  }

  Future<void> addSubcategory(AddSubcategories subcategory) async {
    final response = await _service.addSubcategories(subcategory.toMap());

    // Log the response for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to add subcategory to database: ${response.body}');
    }
  }

  Future<void> addExpense(AddExpense expense) async{
    final response = await _service.addExpense(expense.toMap());

    // Log the response for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to add expense to database: ${response.body}');
    }
  }

  Future<void> addIncome(AddIncome income) async{
    final response = await _service.addIncome(income.toMap());

    // Log the response for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to add income to database: ${response.body}');
    }
  }

  Future<void> updateExpense(UpdateExpense expense) async {
    final response = await _service.updateExpense(
      expense.expenseId,  // Pass the expense ID
      expense.toMap(),    // Convert the expense to a Map
    );

    print("Update Expense - Response status: ${response.statusCode}");
    print("Update Expense - Response body: ${response.body}");

    if (response.statusCode != 200) { // Or the status code your API returns for success
      throw Exception('Failed to update expense: ${response.body}');
    }
  }

  Future<void> updateIncome(UpdateIncome income) async {
    final response = await _service.updateIncome(
      income.incomeId,  // Pass the expense ID
      income.toMap(),    // Convert the expense to a Map
    );

    print("Update Income - Response status: ${response.statusCode}");
    print("Update Income - Response body: ${response.body}");

    if (response.statusCode != 200) { // Or the status code your API returns for success
      throw Exception('Failed to update income: ${response.body}');
    }
  }

  Future<void> deleteExpense(DeleteExpense deleteExpense) async {
    final response = await _service.deleteExpense(deleteExpense.expenseId);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense: ${response.body}');
    }

    print('Expense deleted successfully');
  }

  Future<void> deleteIncome(DeleteIncome deleteIncome) async {
    final response = await _service.deleteIncome(deleteIncome.incomeId);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete income: ${response.body}');
    }

    print('Income deleted successfully');
  }

  // Add a dispose method to clean up resources
  void dispose() {
    _service.dispose(); // Call dispose in the service
    print("Repository resources cleaned up.");
  }


}