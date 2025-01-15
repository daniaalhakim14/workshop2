import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:workshop_2/Model/Analysis.dart';
import 'package:http/http.dart' as http;

class AnalysisViewModel extends ChangeNotifier {
  AnalysisViewModel () {
    _loadEnvVariables();
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
        await generateSavingMaximization(expenseJson);
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

  Future<void> _loadEnvVariables() async {
    _apiKey = 'AIzaSyA-17gjtuzrkLq4eoKkjjL5cWQSvGVCG70';

    if (_apiKey == null) {
      // Handle the error gracefully
      print('No GEMINI_API_KEY environment variable found.');
      // You might want to notify the user or set an error state here
    }
  }

  Future<void> generateSavingMaximization(List<dynamic> expenseJson) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    if (_apiKey == null) {
      _error: 'API key is not initialized.';
      return; // Exit early if the API key is not available
    }

    try {

      final model = _createGenerativeModel();
      final chat = model.startChat(history: _buildChatHistory());

      final message = 'Overall:\nTotal Budget: RM $totalBudget\nTotal Expense: RM $totalExpense\nCategory:\n$expenseJson';
      final content = Content.text(message);

      final response = await chat.sendMessage(content);

      _savingMaximization = response.text;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print(_error);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  GenerativeModel _createGenerativeModel() {
    return GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: _apiKey!,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );
  }

  List<Content> _buildChatHistory() {
    return [
      Content.multi([
        TextPart('I will give you the analysis about the budgets and the real expenses. Please give some saving maximization recommendation. Just straight to the point, avoid useless information, but the important point please elaborate more.\n\nOverall:\nTotal Budget: RM 3500\nTotal Expense: RM 4000\n\nCategory:\n{\n    "expenses": [\n        {\n            "category_name": "Food",\n            "budget_amount": "150.00",\n            "expense_amount": "145.50"\n        },\n        {\n            "category_name": "Healthcare",\n            "budget_amount": "100.00",\n            "expense_amount": "50.00"\n        },\n        {\n            "category_name": "Personal",\n            "budget_amount": "100.00",\n            "expense_amount": "75.00"\n        }\n    ]\n}\n'),
      ]),
      Content.model([
        TextPart('**Problem:** You\'ve overspent by RM 500, and a large sum (RM 3729.50) is unaccounted for. This indicates a significant discrepancy between your budget and actual spending.\n\n**Recommendations:**\n\n1.  **Detailed Expense Tracking (Crucial):** The first and most important step is to identify *exactly* where the missing RM 3729.50 went. Scrutinize your bank statements, credit card bills, and any other spending records. Categorize these expenses specifically. Don\'t just put them in "miscellaneous." Understand if it was transport, entertainment, shopping, or debt payments. Knowing where your money is going is the foundation for creating a better budget. This will highlight areas for potential reduction.\n\n2.  **Immediate Non-Essential Spending Cuts:** Once you have a grasp on where your money is going, you need to cut back on non-essential items *immediately*. This means things like entertainment, eating out, impulse purchases, and subscriptions. Reducing these expenses will provide immediate savings and help you get back on track. The goal here is to bring spending in line with your budget.\n\n3.  **Realistic Budget Revision (Essential):** Your current budget is not working, given the overspend. It\'s imperative to create a new budget that is based on your *actual spending habits*, not on what you *wish* you were spending. Analyze the categories identified in step 1 and allocate amounts that are feasible for you. Ensure you include a buffer within each category to account for unexpected costs. This will prevent future overspending.\n\n4.  **Emergency Fund (Important):** It\'s essential to start saving towards an emergency fund. This fund will be a safety net for unforeseen expenses. A good goal is to have 3-6 months of living expenses saved. Start with small amounts that you can realistically afford, and gradually increase your contribution. This will provide financial security and reduce the need for debt if unexpected costs arise.\n\n5.  **Address Debt (If Applicable):** If the overspending is linked to debt, create a debt repayment plan. Prioritize debts with high-interest rates. Aim to pay more than the minimum payments to reduce the principal quickly. Having a debt repayment plan will further alleviate your financial concerns.\n\n**Action:** *Track* your expenses diligently, *cut* non-essential spending now, and develop a *realistic budget* and *savings plan*. This combination will help you gain control over your finances.\n'),
      ]),
      Content.multi([
        TextPart('Overall:\nTotal Budget: RM 3500\nTotal Expense: RM 4000\n\nCategory:\n{\n    "expenses": [\n        {\n            "category_name": "Food",\n            "budget_amount": "150.00",\n            "expense_amount": "145.50"\n        },\n        {\n            "category_name": "Healthcare",\n            "budget_amount": "100.00",\n            "expense_amount": "50.00"\n        },\n        {\n            "category_name": "Personal",\n            "budget_amount": "100.00",\n            "expense_amount": "75.00"\n        }\n    ]\n}'),
      ]),
      Content.model([
        TextPart('**Problem:** Overspent RM 500. Unaccounted expenses total RM 3729.50. This signifies a severe budget misalignment.\n\n**Recommendations:**\n\n1.  **Detailed Expense Analysis (Critical):** Identify the missing RM 3729.50. Thoroughly examine bank statements, receipts, and any other spending records. Categorize *every* expense, even small ones, to understand where money is leaking. The more detailed your categorization, the better you can understand your spending habits. Avoid broad categories such as "miscellaneous" and break it down into very specific sub categories, like \'transportation-car\', or \'entertainment-movies\'.\n\n2.  **Immediate Spending Reductions (Essential):** Immediately cut non-essential spending. This includes entertainment, dining out, impulse purchases, subscriptions, etc. This is not about permanent deprivation, but rather an immediate recalibration of spending to align with your budget. Aim to reduce spending in all areas that are not absolutely required.\n\n3.  **Realistic Budget Creation (Crucial):** Your current budget isn\'t working. Therefore, a new budget should be built based on *your actual spending patterns*. This is very important. Be realistic in your allocations, and include a buffer for unexpected expenses within each category.\n\n4.  **Emergency Fund (Important):** Build an emergency fund covering 3-6 months of essential living expenses. This should be a priority, starting with whatever amount you can reasonably save each month.\n\n5.  **Debt Management (If Applicable):** If the overspending is related to debt, create a strategy for paying it down, beginning with any high-interest debts.\n\n**Action:** You *must* identify where the missing money is going, *immediately cut* back on non-essential spending, and build a *realistic budget and savings plan* to correct the overspending.\n'),
      ]),
    ];
  }
}