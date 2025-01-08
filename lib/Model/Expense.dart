class Expense {
  final int? expenseid;
  final double amount;
  final String date;
  final String description;
  final String paymenttype;
  final int userid;
  final int subcategoryid;
  final int parentcategoryid;

  Expense({
    this.expenseid,
    required this.amount,
    required this.date,
    required this.description,
    required this.paymenttype,
    required this.userid,
    required this.subcategoryid,
    required this.parentcategoryid
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    expenseid: json['expenseid'],
    amount: double.parse(json['amount']),
    date: json['date'],
    description: json['description'],
    paymenttype: json['paymenttype'],
    userid: json['userid'],
    subcategoryid: json['subcategoryid'],
    parentcategoryid: json['parentcategoryid']
  );
}

class ExpenseBudget {
  final int basiccategoryid;
  final double total_amount;

  ExpenseBudget({
    required this.basiccategoryid,
    required this.total_amount,
  });

  factory ExpenseBudget.fromJson(Map<String, dynamic> json) => ExpenseBudget(
    basiccategoryid: json['basiccategoryid'],
    total_amount: double.parse(json['total_amount'])
  );
}