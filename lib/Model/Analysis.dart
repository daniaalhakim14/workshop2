class AnalysisData {
  final String category_name;
  final double budget_amount;
  final double expense_amount;

  AnalysisData({
    required this.category_name,
    required this.budget_amount,
    required this.expense_amount,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) => AnalysisData(
    category_name: json['category_name'],
    budget_amount: double.parse(json['budget_amount']),
    expense_amount: double.parse(json['expense_amount'])
  );
}