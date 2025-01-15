import 'package:flutter/material.dart';

class BudgetTextFieldViewModel extends ChangeNotifier {
  final TextEditingController budgetNameController = TextEditingController();
  final TextEditingController budgetAmountController = TextEditingController();
  String _budgetNameValue = '';
  String _budgetAmountValue = '';

  String get budgetNameValue => _budgetNameValue;
  String get budgetAmountValue => _budgetAmountValue;

  void updateTextFieldValue() {
    _budgetNameValue = budgetNameController.text;
    _budgetAmountValue = budgetAmountController.text;
    notifyListeners(); // Notify listeners to update the UI
  }

  @override
  void dispose() {
    budgetNameController.dispose(); // Dispose the controller when done
    budgetAmountController.dispose();
    super.dispose();
  }
}