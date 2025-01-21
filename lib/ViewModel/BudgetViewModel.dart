import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/Budget.dart';
import '../Model/Category.dart';
import 'package:intl/intl.dart';

import '../configure_API.dart';
import 'ExpenseViewModel.dart';

class BudgetViewModel extends ChangeNotifier {
  final String apiUrl = '${AppConfig.baseUrl}/budget';
  bool _isLoading = false;
  String? _error;
  BudgetResponse? budgetresponse;
  List<Budget> _budgets = [];
  List<BudgetDisplay> _budgetdisplay = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Budget>? get budgets => _budgets;
  List<BudgetDisplay> get budgetdisplay => _budgetdisplay;

  Future<void> fetchBudgets(int userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await http.get(
        Uri.parse(
            '$apiUrl/$userId'),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final List<dynamic> budgetJson = json.decode(response.body)['budget'];
        _budgets = budgetJson.map((json) => Budget.fromJson(json)).toList();
        _budgets = mergeBudgets(_budgets);

        final expenseViewModel = ExpenseViewModel();
        //
        // // Call fetchBudgetExpenses for each budget
        // for (var budget in _budgets) {
        //   // Assuming budget has an id and you need to pass it to fetchBudgetExpenses
        //   double totalAmount = await expenseViewModel.fetchExpenseBudget(userId, budget.basiccategoryids!, budget.startdate);
        //   // You can store the total amount in the budget object or handle it as needed
        //   budget.totalexpense = totalAmount; // Assuming you have a totalAmount field in your Budget model
        // }

        List<Future<void>> fetchFutures = _budgets.map((budget) async {
          if (budget != null) {
            try {
              double totalAmount = await expenseViewModel.fetchExpenseBudget(
                userId,
                budget.basiccategoryids!,
                budget.startdate,
              );
              budget.totalexpense = totalAmount;// Update budget with expense
            } catch (e) {
              print('Error fetching expenses for budget ${budget.budgetid}: $e');
            }
          } else {
            print('Warning: Encountered a null budget, skipping expense fetch.');
          }
        }).toList();

        // Wait for all fetch operations to complete
        await Future.wait(fetchFutures);

        // Once all budgets are processed, create the budget display
        _budgetdisplay = displayBudgets();
      } else if (response.statusCode == 404) {
        _error = 'No budget found';
      } else {
        _error = 'Failed to load budgets: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching budgets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Budget> mergeBudgets(List<Budget> budgets) {
    Map<int, Budget> mergedBudgets = {};

    for (var budget in budgets) {
      if (mergedBudgets.containsKey(budget.budgetid)) {
        // If the budgetId already exists, sum the amounts
        mergedBudgets[budget.budgetid]!.amount = budget.amount;
      } else {
        // If it doesn't exist, add the budget to the map
        mergedBudgets[budget.budgetid!] = budget;
      }
    }

    // Convert the map back to a list of Budget
    return mergedBudgets.values.toList();
  }

  List<BudgetDisplay> displayBudgets() {
    List<BudgetDisplay> budgetDisplays = [];

    for (var budget in _budgets) {
      if (budget != null && budget.totalexpense != null) { // Check for null before creating BudgetDisplay
        BudgetDisplay budgetDisplay = BudgetDisplay.fromBudget(budget);
        print(budget.totalexpense);
        budgetDisplays.add(budgetDisplay); // Add to the list
      } else {
        print('Warning: Skipping incomplete budget ${budget?.budgetid}.');
      }
    }
    return budgetDisplays;
  }

  Future<void> postBudgetCategory(List<BudgetCategory> budgetcategories) async {
    try {
      _error = null;
      // Convert the Budget object to JSON
      final response = await http.post(
        Uri.parse('$apiUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(budgetcategories.map((category) => category.toJson()).toList()),
      );

      if (response.statusCode == 201) {
        // Successfully created
        // If the server returns a 201 CREATED response, parse the JSON
        print("budget created completely");
      }
      else if (response.statusCode == 400) {
        _error = "Budget with the same name and start date already exists.";
        throw Exception(_error);
      } else {
        // Handle error
        _error = "Fail to create budget";
        throw Exception(_error);
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred: $e');
      throw Exception(e);
    }
  }

  Future<BudgetResponse> postBudget(Budget budget) async {
    try {
      _error = null;
      // Convert the Budget object to JSON
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'budgetname': budget.budgetname,
          'amount': budget.amount,
          'startdate': budget.startdate,
          'recurrence': budget.recurrence,
          'userid': budget.userid,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created
        // If the server returns a 201 CREATED response, parse the JSON
        return BudgetResponse.fromJSON(json.decode(response.body));
      }
      else if (response.statusCode == 400) {
        _error = "Budget with the same name and start date already exists.";
        throw Exception(_error);
      } else {
        // Handle error
        _error = "Fail to create budget";
        throw Exception(_error);
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred: $e');
      throw Exception(e);
    }
  }

  List<BudgetCategory> generateBudgetCategories({
    required int budgetid,
    required List<Category> categorylist,
    required double amount,
  }) {
    return categorylist.map((category) {
      return BudgetCategory(
        budgetid: budgetid,
        basiccategoryid: category.basiccategoryid,
        amount: amount,
      );
    }).toList();
  }

  Future<void> createBudget({
    required String name,
    required String amount,
    required String startdate,
    required String recurrence,
    required int userid,
    required List<Category> categories,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Validate inputs
      if (name.isEmpty || amount.isEmpty) {
        throw Exception('Please fill in all required fields');
      }

      if (categories.isEmpty) {
        throw Exception('Please select the category / categories');
      }

      // Convert amount to double
      final double? budgetAmount = double.tryParse(amount);

      if (budgetAmount == null) {
        throw Exception('Please enter the valid amount');
      }

      // Create budget object
      final budget = Budget(
        budgetname: name,
        amount: budgetAmount,
        startdate: startdate,
        recurrence: recurrence,
        userid: userid,
      );

      budgetresponse = await postBudget(budget);

      if (budgetresponse != null) {
        List<BudgetCategory> budgetcategories = generateBudgetCategories(
            budgetid: budgetresponse?.budgetid ?? 0,
            categorylist: categories,
            amount: budgetAmount
        );

        await postBudgetCategory(budgetcategories);
      }
    } catch (e) {
      _error = e.toString();
      print('Error creating budget: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postBudgets(List<AIGeneratedBudget> aibudgets, int userid) async {
    // Convert AI-generated budgets to budgets
    List<Budget> budgets = convertAIGeneratedBudgetsToBudgets(aibudgets, userid);

    // Reset error state and notify listeners
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait(budgets.map((budget) async {
        final response = await http.post(
          Uri.parse('$apiUrl/budgetandcategory'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'budgetname': budget.budgetname,
            'amount': budget.amount,
            'startdate': budget.startdate,
            'recurrence': budget.recurrence,
            'userid': budget.userid,
            'basiccategoryid': budget.basiccategoryid,
          }),
        );

        if (response.statusCode != 201) {
          if (response.statusCode == 400) {
            throw Exception(
                "Budget '${budget.budgetname}' with the same start date already exists.");
          } else {
            throw Exception("Failed to create budget '${budget.budgetname}'.");
          }
        }
      }));
    } catch (e) {
      _error = e.toString(); // Capture error for UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Budget> convertAIGeneratedBudgetsToBudgets(List<AIGeneratedBudget> aiGeneratedBudgets, int userId) {
    return aiGeneratedBudgets.map((aiBudget) {
      return Budget(
        budgetname: aiBudget.budgetname,
        amount: aiBudget.amount,
        startdate: DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, 1)), // Set a default start date or modify as needed
        recurrence: 'Monthly', // Set a default recurrence or modify as needed
        userid: userId, // Pass the user ID as needed
        basiccategoryid: aiBudget.categoryid, // Assuming you want to convert categoryid to int
      );
    }).toList();
  }

  Future<void> updateBudget(int budgetid, String budgetname, double budgetamount, String startdate) async {

    // Reset error state and notify listeners
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'budgetid': budgetid,
          'budgetname': budgetname,
          'budgetamount': budgetamount,
          'startdate': startdate,
        }),
      );

      if (response.statusCode != 201) {
        _error = "Failed to update budget '${budgetid}'.";
      }

    } catch (e) {
      _error = e.toString(); // Capture error for UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(int budgetid) async {

    // Reset error state and notify listeners
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'budgetid': budgetid
        }),
      );

      if (response.statusCode != 201) {
        _error = "Failed to delete budget '${budgetid}'.";
      }

    } catch (e) {
      _error = e.toString(); // Capture error for UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}