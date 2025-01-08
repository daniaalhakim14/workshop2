import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:workshop_2/Model/Analysis.dart';
import 'package:http/http.dart' as http;

class AnalysisViewModel extends ChangeNotifier {
  AnalysisViewModel () {
  }

  final String apiUrl = 'http://192.168.0.3:3000/analysis';
  bool _isLoading = false;
  String? _error;
  List<AnalysisData> _analysis = [];
  double _totalBudget = 0.0;
  double _totalExpense = 0.0;
  String? _savingMaximization;
  String? _apiKey;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AnalysisData> get analysis => _analysis;
  double get totalBudget => _totalBudget;
  double get totalExpense => _totalExpense;
  String? get savingMaximization => _savingMaximization;

  Future<void> fetchAnalysis(int userid, String date) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl?userid=$userid&date=$date'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> expenseJson = json.decode(response.body)['expenses'];
        _analysis = expenseJson.map((json) => AnalysisData.fromJson(json)).toList();
        await calculateTotals(_analysis);
      }
      else if (response.statusCode == 404) {
        _analysis = [];
        _error = 'No analysis found';
      }
      else {
        _error = 'Failed to load analysis: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching analysis: $e';
    } finally {
      _isLoading = false;
      print('error: $_error');
      notifyListeners();
    }
  }

  Future<void> calculateTotals(List<AnalysisData> analysisDataList) async {
    _totalBudget = analysisDataList.fold(0.0, (sum, item) => sum + item.budget_amount);
    _totalExpense = analysisDataList.fold(0.0, (sum, item) => sum + item.expense_amount);
  }
}