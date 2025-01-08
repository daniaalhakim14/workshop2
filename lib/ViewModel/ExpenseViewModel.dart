import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/Expense.dart';

class ExpenseViewModel extends ChangeNotifier {
  final String apiUrl = 'http://192.168.0.3:3000/expense';
  bool _isLoading = false;
  String? _error;
  List<Expense> _expenses = [];
  List<ExpenseBudget> _expensebudget = [];
  double _expenseBudgetTotalAmount = 0.0;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Expense> get expenses => _expenses;
  List<ExpenseBudget> get expensebudget => _expensebudget;
  double get expenseBudgetTotalAmount => _expenseBudgetTotalAmount ;

  Future<void> fetchBudgets(int userid, String date) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/specific?userid=$userid&date=$date'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> expenseJson = json.decode(response.body)['expeses'];
        _expenses = expenseJson.map((json) => Expense.fromJson(json)).toList();
      }
      else if (response.statusCode == 404) {
        _error = 'No expense found';
      }
      else {
        _error = 'Failed to load expenses: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching budgets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<double> fetchExpenseBudget(int userId, List<int> categoryIds, String date) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/budget?userid=$userId&categoryids=${categoryIds.join(',')}&date=$date'),
      );

      if (response.statusCode == 200) {
        print('$apiUrl/budget?userid=$userId&categoryids=${categoryIds.join(',')}&date=$date');
        print('API Response: ${response.body}');
        final data = jsonDecode(response.body);
        _expensebudget = (data['expenses'] as List)
            .map((expensebudget) => ExpenseBudget.fromJson(expensebudget))
            .toList();
        print('expensebudget: $_expensebudget');
        return _expenseBudgetTotalAmount = _expensebudget.fold(0.0, (sum, expensebudget) => sum + expensebudget.total_amount);
      } else {
        _error = 'Failed to load expenses: ${response.body}';
        throw Exception(_error);
      }
    } catch (e) {
      _error = e.toString();
      throw Exception(_error);
    }
  }
}