// A bridge between view layer and repository (data layer)

import 'package:flutter/material.dart';

import '../../Model/InsightPage_model.dart';
import 'InsightPage_Repository.dart';


// ChangeNotifier allows View Model to notify listeners when data changes
class InsightViewModel extends ChangeNotifier{

  final repository = InsightRepository();
  final InsightRepository _repository = InsightRepository();

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

  Future<void> fetchTransactionsExpense(int userid) async {
    fetchingData = true; // Indicate that data fetching is in progress
    notifyListeners();

    try {
      _transactionsExpense = await repository.getTransactionsExpense(userid);
    } catch (e) {
      print('Failed to load transaction expenses: $e');
      _transactionsExpense = [];
    } finally {
      fetchingData = false; // Data fetching completed
      notifyListeners();
    }
  }

  Future<void> fetchTransactionList(int userid) async {
    fetchingData = true; // Indicate that data fetching is in progress
    notifyListeners();

    try {
      _transactionList = await repository.getTransactionList(userid);
      print('Loaded Transaction list: $_transactionList');
    } catch (e, stackTrace) {
      print('Failed to load transaction list: $e');
      print('Stack trace: $stackTrace'); // Log the stack trace
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

  Future<void> fetchSubcategories(int parentCategoryId, int userid) async {
    fetchingData = true;
    _subcategory = []; // Clear the subcategory list
    notifyListeners();
    try {
      _subcategory = await repository.getSubcategories(parentCategoryId,userid);
      //print('Loaded Subcategories: $_subcategory');
    } catch (e) {
      print('Failed to load Basic Category: $e');
      _subcategory = [];
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }
/*
  Future<void> fetchSubcategoriesForUser(int parentCategoryId, int userid) async {
      fetchingData = true;
      _subcategory = []; // Clear the subcategory list
      notifyListeners();
      try {
        _subcategory = await repository.getSubcategories(parentCategoryId,userid);
        //print('Loaded Subcategories: $_subcategory');
      } catch (e) {
        print('Failed to load Basic Category: $e');
        _subcategory = [];
      } finally {
        fetchingData = false;
        notifyListeners();
      }
    }
*/
  Future<void> addIcon(AddIcon icon) async {
    try {
      await repository.addIcon(icon);
    } catch (e) {
      print('Failed to add icon: $e');
    }
  }

  Future<bool> addSubcategory(AddSubcategories subcategory, int userid) async {
    try {
      await repository.addSubcategory(subcategory,userid);
      notifyListeners();
      return true; // Indicate success
    } catch (e) {
      print('Failed to add subcategory: $e');
      return false; // Indicate failure
    }
  }

  Future<void> addExpense(AddExpense expense) async{
    try{
      await repository.addExpense(expense);
    }catch (e){
      print('Failed to add new expense: $e');
    }
  }

  Future<void> addIncome(AddIncome income) async{
    try{
      await repository.addIncome(income);
    }catch (e){
      print('Failed to add new income: $e');
    }
  }

  Future<void> updateExpense(UpdateExpense expense) async {
    try {
      await repository.updateExpense(expense);
    } catch (e) {
      print('Failed to update expense: $e');
    }
  }

  Future<void> updateIncome(UpdateIncome income) async {
    try {
      await repository.updateIncome(income);
    } catch (e) {
      print('Failed to update income: $e');
    }
  }

  Future<void> deleteExpense(int expenseId,int userid) async {
    try {
      await repository.deleteExpense(DeleteExpense(expenseId: expenseId),userid);
      print('Transaction deleted successfully!');

      // Refresh the transaction list after deletion
      await fetchTransactionList(userid);
      await fetchTransactionsExpense(userid);
    } catch (e) {
      print('Failed to delete transaction: $e');
    }
  }

  Future<void> deleteIncome(int incomeId,int userid) async {
    try {
      await repository.deleteIncome(DeleteIncome(incomeId: incomeId),userid);
      print('Transaction deleted successfully!');

      // Refresh the transaction list after deletion
      await fetchTransactionList(userid);
      await fetchTransactionsExpense(userid);
    } catch (e) {
      print('Failed to delete transaction: $e');
    }
  }

  @override
  void dispose() {
    _repository.dispose(); // Call repository's dispose method
    super.dispose();
    print("ViewModel disposed.");
  }


}





