import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:workshop_2/Model/Budget.dart';
import 'package:workshop_2/View/ai_budget.dart';

class AIBudgetViewModel extends ChangeNotifier {
  AIBudgetViewModel() {
    _loadEnvVariables();
  }

  bool _isLoading = false;
  String? _error;
  String? _apiKey;
  List<AIGeneratedBudget> _aibudgets = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AIGeneratedBudget> get aibudgets => _aibudgets;

  Future<void> _loadEnvVariables() async {
    _apiKey = 'AIzaSyA-17gjtuzrkLq4eoKkjjL5cWQSvGVCG70';

    if (_apiKey == null) {
      // Handle the error gracefully
      print('No GEMINI_API_KEY environment variable found.');
      // You might want to notify the user or set an error state here
    }
  }

  Future<void> generateAIBudget(String monthlyIncome, String essentialExpenses, String variableExpenses, String savingGoals) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    if (_apiKey == null) {
      _error: 'API key is not initialized.';
      return; // Exit early if the API key is not available
    }

    try {
      if (monthlyIncome.isEmpty || essentialExpenses.isEmpty || variableExpenses.isEmpty || savingGoals.isEmpty) {
        throw Exception('Please fill in all required fields');
      }

      double? monthly_income = double.tryParse(monthlyIncome);
      double? essential_expenses = double.tryParse(essentialExpenses);
      double? variable_expenses = double.tryParse(variableExpenses);
      double? saving_goals = double.tryParse(savingGoals);

      if (monthly_income == null || essential_expenses == null || variable_expenses == null || saving_goals == null) {
        throw Exception('Please enter the valid value');
      }

      final model = _createGenerativeModel();
      final chat = model.startChat(history: _buildChatHistory());

      final message = 'The category id just base on this only:\n1.Food2.Transportation\n3.Entertainment\n4.Housing\n5.ShoppingMonthly \nIncome: $monthly_income\nEssential Expenses: $essential_expenses\nVariable Expenses: $variable_expenses\nSaving Goals In 10 Years: $saving_goals';
      final content = Content.text(message);

      final response = await chat.sendMessage(content);

      String cleanedResponse = response.text!.replaceAll(RegExp(r'```json|```'), '').trim();

      final Map<String, dynamic> jsonResponse = jsonDecode(cleanedResponse);
      if (jsonResponse.containsKey('budgets')) {
        final List<dynamic> budgetJson = jsonResponse['budgets'];
        _aibudgets = budgetJson.map((json) => AIGeneratedBudget.fromJson(json)).toList();
      } else {
        throw Exception('Key "budgets" not found in the response.');
      }
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
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n6. Others\n\nReturn in JSON format like this:\n{\n  [\n    {\n      budgetname:\n      category:\n      amount:\n    }\n  ]\n}'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "monthlyBudget": [\n    {\n      "budgetname": "Housing",\n      "category": "Essential",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Food",\n       "category": "Variable",\n      "amount": 400\n    },\n     {\n      "budgetname": "Transportation",\n       "category": "Variable",\n      "amount": 300\n    },\n    {\n      "budgetname": "Entertainment",\n      "category": "Variable",\n      "amount": 100\n    },\n     {\n      "budgetname": "Savings",\n       "category":"Savings",\n      "amount": 833\n    },\n    {\n      "budgetname": "Others",\n      "category": "Variable",\n      "amount": 1167\n    }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n6. Others\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname:\n      category:\n      amount:\n    }\n  ]\n}'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Housing",\n      "category": "Essential",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Food",\n       "category": "Variable",\n      "amount": 400\n    },\n     {\n      "budgetname": "Transportation",\n       "category": "Variable",\n      "amount": 300\n    },\n    {\n      "budgetname": "Entertainment",\n      "category": "Variable",\n      "amount": 100\n    },\n     {\n      "budgetname": "Savings",\n       "category":"Savings",\n      "amount": 417 \n    },\n    {\n      "budgetname": "Others",\n      "category": "Variable",\n      "amount": 2583\n    }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n6. Others\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname: Budget Food\n      category: Food\n      amount: 200\n    }\n  ]\n}'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Housing",\n      "category": "Housing",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Food",\n      "category": "Food",\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "category": "Transportation",\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "category": "Entertainment",\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Savings",\n      "category": "Savings",\n      "amount": 417\n    },\n    {\n      "budgetname": "Budget Others",\n      "category": "Others",\n      "amount": 2583\n    }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname: Budget Food\n      category: Food\n      amount: 200\n    }\n  ]\n}'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Food",\n      "category": "Food",\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "category": "Transportation",\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "category": "Entertainment",\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Housing",\n      "category": "Housing",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Savings",\n      "category": "Savings",\n      "amount": 417\n    }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\nstart date: 2024-12-01\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname: Budget Food\n      categoryid: 1\n      amount: 200\n    },\n    {\n      budgetname: Budget Transportation\n      categoryid: 2\n      amount: 100\n    }\n  ]\n}'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Food",\n      "categoryid": 1,\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "categoryid": 2,\n      "amount": 300\n    },\n     {\n      "budgetname": "Budget Entertainment",\n      "categoryid": 3,\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Housing",\n      "categoryid": 4,\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Savings",\n      "categoryid": 5,\n       "amount": 417\n    }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\nstart date: 2024-12-01\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Shopping\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname: Budget Food\n      categoryid: 1\n      amount: 200\n    },\n    {\n      budgetname: Budget Transportation\n      categoryid: 2\n      amount: 100\n    }\n  ]\n}'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Food",\n      "categoryid": 1,\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "categoryid": 2,\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "categoryid": 3,\n      "amount": 100\n    },\n     {\n      "budgetname": "Budget Housing",\n      "categoryid": 4,\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Shopping",\n      "categoryid": 5,\n      "amount": 2583\n    }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 3000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 30000'),
      ]),
      Content.model([
        TextPart('Okay, I can help you create a budget based on that information. Here\'s a breakdown of how we\'ll approach it and the resulting JSON output:\n\n**Understanding the Constraints**\n\n*   **Monthly Income:** \$3000\n*   **Essential Expenses:** \$2000 (This is typically things like rent/mortgage, utilities, debt payments, etc. We won\'t break it down further in this example, but it\'s something you would track in real life)\n*   **Variable Expenses:** \$500 (This covers things like food, transportation, entertainment, etc.)\n*   **Savings Goal:** \$30,000 in 10 years. This means saving \$3000 per year, or \$250 per month.\n\n**Budget Categories & Allocation**\n*   **Housing** Will be assumed to take a portion of essential expenses\n*   **Food:** A portion of variable expenses\n*   **Transportation:** A portion of variable expenses\n*   **Entertainment:** A portion of variable expenses\n*   **Savings:** Based on a goal of 30000 in 10 years.\n*   **Others:** A portion of remaining variable expenses and after savings.\n\n**JSON Output**\n```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Housing",\n      "categoryid": 1,\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Food",\n      "categoryid": 2,\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "categoryid": 3,\n      "amount": 100\n    },\n     {\n      "budgetname": "Budget Entertainment",\n      "categoryid": 4,\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Savings",\n      "categoryid": 5,\n      "amount": 250\n    },\n     {\n      "budgetname":"Budget Others",\n      "categoryid":6,\n      "amount":1050\n     }\n  ]\n}\n```\n\n**Explanation**\n1. **Housing**: Assigned 1200 which is part of the 2000 essential expenses.\n2. **Food:** 300 a reasonable portion of the 500 variable expenses.\n3. **Transportation:** Assigned 100, part of variable expenses.\n4. **Entertainment:** Assigned 100 part of variable expenses.\n5. **Savings:** Calculated 30000 in 10 years = 3000 per year or 250 per month\n6. **Others**: The remaining after savings and variable expenses are added up. This category can contain other unexpected expenses or personal expenses.\n\n**Important Notes:**\n\n*   **Flexibility:** This is just a template. You can adjust the amounts in each category to match your own priorities and spending habits.\n*   **Tracking:** To make this budget effective, you *must* track your spending in each category. There are many budgeting apps and spreadsheets you can use to do that.\n*   **Review:** It\'s recommended to review your budget regularly (at least once a month) and make adjustments as needed. Your spending patterns may change over time.\n*   **Emergency Fund:** This budget does not specifically allocate for an emergency fund. If you don\'t have one, that should be your priority before focusing on long-term savings. I would recommend adjusting the "Others" category or the savings to allow for emergency saving goals.\n\nLet me know if you\'d like to explore a specific area or want to try variations on this budget.\n'),
      ]),
      Content.multi([
        TextPart('just return the json response is enough'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Housing",\n      "categoryid": 1,\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Food",\n      "categoryid": 2,\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "categoryid": 3,\n      "amount": 100\n    },\n     {\n      "budgetname": "Budget Entertainment",\n      "categoryid": 4,\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Savings",\n      "categoryid": 5,\n      "amount": 250\n    },\n     {\n      "budgetname":"Budget Others",\n      "categoryid":6,\n      "amount":1050\n     }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Housing",\n      "categoryid": 1,\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Food",\n      "categoryid": 2,\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "categoryid": 3,\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "categoryid": 4,\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Savings",\n      "categoryid": 5,\n      "amount": 417\n    },\n     {\n      "budgetname":"Budget Others",\n      "categoryid":6,\n      "amount":2583\n     }\n  ]\n}\n```\n'),
      ]),
      Content.multi([
        TextPart('Monthly Income: 6000\nEssential Expenses: 3000\nVariable Expenses: 1000\nSaving Goals In 10 Years: 20000'),
      ]),
      Content.model([
        TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Housing",\n      "categoryid": 1,\n      "amount": 1800\n    },\n    {\n      "budgetname": "Budget Food",\n      "categoryid": 2,\n      "amount": 500\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "categoryid": 3,\n       "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "categoryid": 4,\n      "amount": 200\n    },\n    {\n      "budgetname": "Budget Savings",\n      "categoryid": 5,\n      "amount": 167\n    },\n     {\n      "budgetname":"Budget Others",\n      "categoryid":6,\n       "amount": 3033\n    }\n  ]\n}\n```\n'),
      ]),
    ];
  }
}