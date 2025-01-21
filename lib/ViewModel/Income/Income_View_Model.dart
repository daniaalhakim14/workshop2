import 'package:flutter/material.dart';
import '../../Model/Income_model.dart';
import 'Income_Repository.dart';

class IncomeViewModel extends ChangeNotifier {
  final IncomeRepository _repository = IncomeRepository();
  bool fetchingData = false;

  List<IncomeAmount> _incomeAmount = [];
  List<IncomeAmount> get incomeAmount => _incomeAmount;

  Future<void> fetchIncomeAmount(int userid) async {
    fetchingData = true;
    notifyListeners();

    try {
      _incomeAmount = await _repository.getIncomeAmount(userid); // Get total income as a double
    } catch (e) {
      print('Failed to load income amount: $e');
      _incomeAmount = []; // Reset to default if error occurs
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }
}


