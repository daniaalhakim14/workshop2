// A bridge between view layer and repository (data layer)

import 'package:flutter/material.dart';
import '../Model/insight_model.dart';
import 'repository.dart';


// ChangeNotifier allows View Model to notify listeners when data changes
class InsightViewModel extends ChangeNotifier{

  bool fetchingData = false;

  List<TransactionsExpense> _transactionsExpense = [];
  List<TransactionsExpense> get transactionsExpense => _transactionsExpense;

  List<TransactionList> _transactionList = [];
  List<TransactionList> get transactionList => _transactionList;
  List<BasicCategories> _basicCategories = [];
  List<BasicCategories> get basicCategories => _basicCategories;
  List<IncomeCategories> _incomeCategories = [];
  List<IncomeCategories> get incomeCategories => _incomeCategories;
  List<Subcategories> _subcategory = [];
  List<Subcategories> get subcategory => _subcategory;

  Future<void> fetchTransactionsExpense() async {
    fetchingData = true; // Indicate that data fetching is in progress
    notifyListeners();

    try {
      final repository = InsightRepository();
      _transactionsExpense = await repository.getTransactionsExpense();
    } catch (e) {
      print('Failed to load transaction expenses: $e');
      _transactionsExpense = [];
    } finally {
      fetchingData = false; // Data fetching completed
      notifyListeners();
    }
  }

  Future<void> fetchTransactionList() async {
    fetchingData = true; // Indicate that data fetching is in progress
    notifyListeners();

    try {
      final repository = InsightRepository();
      _transactionList = await repository.getTransactionList();
      print('Loaded Transaction list: $_transactionList');
    } catch (e) {
      print('Failed to load transaction list: $e');
      _transactionList = [];
    } finally {
      fetchingData = false; // Data fetching completed
      notifyListeners();
    }
  }

  Future<void> fetchBasicCategory() async {
    fetchingData = true;
    notifyListeners();

    try {
      final repository = InsightRepository();
      _basicCategories = await repository.getBasicCategories();
     // print('Loaded Basic Categories: $_basicCategories');
    } catch (e) {
      print('Failed to load Basic Category: $e');
      _basicCategories = [];
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }

  Future<void> fetchIncomeCategory() async {
    fetchingData = true;
    notifyListeners();

    try {
      final repository = InsightRepository();
      _incomeCategories = await repository.getIncomeCategories();
      print('Loaded Income Categories: $_incomeCategories');
    } catch (e) {
      print('Failed to load Income Category: $e');
      _incomeCategories = [];
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubcategories(int parentCategoryId) async {
    fetchingData = true;
    _subcategory = []; // Clear the subcategory list
    notifyListeners();
    try {
      final repository = InsightRepository();
      _subcategory = await repository.getSubcategories(parentCategoryId);
      //print('Loaded Subcategories: $_subcategory');
    } catch (e) {
      print('Failed to load Basic Category: $e');
      _subcategory = [];
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }

  Future<void> addIcon(AddIcon icon) async {
    try {
      final repository = InsightRepository();
      await repository.addIcon(icon);
    } catch (e) {
      print('Failed to add icon: $e');
    }
  }

  Future<bool> addSubcategory(AddSubcategories subcategory) async {
    try {
      final repository = InsightRepository();
      await repository.addSubcategory(subcategory);
      notifyListeners();
      return true; // Indicate success
    } catch (e) {
      print('Failed to add subcategory: $e');
      return false; // Indicate failure
    }
  }

  Future<void> addExpense(AddExpense expense) async{
    try{
      final repository = InsightRepository();
      await repository.addExpense(expense);
    }catch (e){
      print('Failed to add new expense: $e');
    }
  }

  Future<void> addIncome(AddIncome income) async{
    try{
      final repository = InsightRepository();
      await repository.addIncome(income);
    }catch (e){
      print('Failed to add new income: $e');
    }
  }

  Future<void> updateExpense(UpdateExpense expense) async {
    try {
      final repository = InsightRepository();
      await repository.updateExpense(expense);
    } catch (e) {
      print('Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    try {
      final repository = InsightRepository();
      await repository.deleteExpense(DeleteExpense(expenseId: expenseId));
      print('Transaction deleted successfully!');

      // Refresh the transaction list after deletion
      await fetchTransactionList();
      await fetchTransactionsExpense();
    } catch (e) {
      print('Failed to delete transaction: $e');
    }
  }



}
