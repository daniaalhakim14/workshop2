class AnalysisData {
  final String category_name;
  int codepoint;
  String fontfamily;
  int color;
  final double budget_amount;
  final double expense_amount;

  AnalysisData({
    required this.category_name,
    required this.codepoint,
    required this.fontfamily,
    required this.color,
    required this.budget_amount,
    required this.expense_amount,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) => AnalysisData(
    category_name: json['category_name'],
    budget_amount: double.parse(json['budget_amount']),
    codepoint: json['codepoint'],
    fontfamily: json['fontfamily'],
    color: int.parse(json['color']),
    expense_amount: double.parse(json['expense_amount'])
  );
}