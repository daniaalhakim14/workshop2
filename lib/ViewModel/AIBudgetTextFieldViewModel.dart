import 'package:flutter/material.dart';

class AIBudgetTextFieldViewModel extends ChangeNotifier {
  final TextEditingController monthlyIncomeController = TextEditingController();
  final TextEditingController essentialExpensesController = TextEditingController();
  final TextEditingController variableExpensesController = TextEditingController();
  final TextEditingController savingGoalsController = TextEditingController();

  String _monthlyIncomeValue = '';
  String _essentialExpensesValue = '';
  String _variableExpensesValue = '';
  String _savingGoalsValue = '';

  String get monthlyIncomeValue => _monthlyIncomeValue;
  String get essentialExpensesValue => _essentialExpensesValue;
  String get variableExpensesValue => _variableExpensesValue;
  String get savingGoalsValue => _savingGoalsValue;

  AIBudgetTextFieldViewModel() {
    // Listen to changes in the text fields
    monthlyIncomeController.addListener(_updateMonthlyIncome);
    essentialExpensesController.addListener(_updateEssentialExpenses);
    variableExpensesController.addListener(_updateVariableExpenses);
    savingGoalsController.addListener(_updateSavingGoals);
  }

  void _updateMonthlyIncome() {
    _monthlyIncomeValue = monthlyIncomeController.text;
    notifyListeners();
  }

  void _updateEssentialExpenses() {
    _essentialExpensesValue = essentialExpensesController.text;
    notifyListeners();
  }

  void _updateVariableExpenses() {
    _variableExpensesValue = variableExpensesController.text;
    notifyListeners();
  }

  void _updateSavingGoals() {
    _savingGoalsValue = savingGoalsController.text;
    notifyListeners();
  }

  // void updateTextFieldValue() {
  //   _monthlyIncomeValue = monthlyIncomeController.text;
  //   _essentialExpensesValue = essentialExpensesController.text;
  //   _variableExpensesValue = variableExpensesController.text;
  //   _savingGoalsValue = savingGoalsController.text;
  //   notifyListeners();
  // }

  @override
  void dispose() {
    monthlyIncomeController.dispose();
    essentialExpensesController.dispose();
    variableExpensesController.dispose();
    savingGoalsController.dispose();
    super.dispose();
  }
}