import 'package:flutter/foundation.dart';

class Budget {
  final int? budgetid;
  final String budgetname;
  double amount;
  final String startdate;
  final String? recurrence;
  final int userid;
  final int? basiccategoryid;
  List<int>? basiccategoryids;
  String? categorynames;
  double? totalexpense;

  Budget({
    this.budgetid,
    required this.budgetname,
    required this.amount,
    required this.startdate,
    this.recurrence,
    required this.userid,
    this.basiccategoryid,
    this.basiccategoryids,
    this.categorynames,
    this.totalexpense,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    budgetid: json['budgetid'],
    budgetname: json['budgetname'],
    amount: double.parse(json['amount']),
    startdate: json['startdate'],
    recurrence: json['recurrence'],
    userid: json['userid'],
    basiccategoryids: json['basiccategoryids'] != null
        ? (json['basiccategoryids'] as String) // Ensure it's treated as a String
        .split(',')
        .map((id) => int.parse(id.trim())) // Convert each ID to int
        .toList()
        : null, // Handle null case
    categorynames: json['categorynames'],
  );
}

class BudgetResponse {
  final int budgetid;
  final String message;

  BudgetResponse({
    required this.budgetid,
    required this.message,
  });

  factory BudgetResponse.fromJSON(Map<String, dynamic> json) => BudgetResponse(
    budgetid: json['budgetid'],
    message: json['message'],
  );
}

class BudgetCategory {
  final int budgetid;
  final int basiccategoryid;
  final double amount;

  BudgetCategory({
    required this.budgetid,
    required this.basiccategoryid,
    required this.amount,
  });

  factory BudgetCategory.fromJSON(Map<String, dynamic> json) => BudgetCategory(
    budgetid: json['budgetid'],
    basiccategoryid: json['basiccategoryid'],
    amount: json['amount'],
  );

  Map<String, dynamic> toJson() {
    return {
      'budgetid': budgetid,
      'basiccategoryid': basiccategoryid,
      'amount': amount,
    };
  }
}

class BudgetDisplay {
  final int budgetId;
  final String budgetName;
  final double amountLeft;
  final double totalAmount;
  final double progressPercentage;
  final String date;
  final String categorynames;

  BudgetDisplay({
    required this.budgetId,
    required this.budgetName,
    required this.amountLeft,
    required this.totalAmount,
    required this.progressPercentage,
    required this.date,
    required this.categorynames,
  });

  // Factory method to create BudgetDisplay from Budget
  factory BudgetDisplay.fromBudget(Budget budget) {
    double amountLeft = budget.amount - budget.totalexpense!; // Calculate amount left
    double progressPercentage = (budget.totalexpense! / budget.amount) * 100; // Calculate progress percentage

    String formattedDate = DateTime.parse(budget.startdate).month.toString() + ' ' + DateTime.parse(budget.startdate).year.toString();

    return BudgetDisplay(
      budgetId: budget.budgetid!,
      budgetName: budget.budgetname,
      amountLeft: amountLeft,
      totalAmount: budget.amount,
      progressPercentage: progressPercentage,
      date: formattedDate,
      categorynames: budget.categorynames!,
    );
  }
}

class AIGeneratedBudget {
  final String budgetname;
  final double amount;
  final int categoryid;

  AIGeneratedBudget({
    required this.budgetname,
    required this.amount,
    required this.categoryid,
  });

  factory AIGeneratedBudget.fromJson(Map<String, dynamic> json) => AIGeneratedBudget(
    budgetname: json['budgetname'],
    // amount: double.parse(json['amount']),
    amount: json['amount'].toDouble(),
    categoryid: json['categoryid'].toInt(),
  );
}