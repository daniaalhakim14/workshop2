class IncomeAmount {
  final int? incomeid;
  final double? incomeAmount;
  final DateTime? date;
  final String? description;
  final String? paymenttype;
  final int? userid;
  final int? incomecategoryid;

  IncomeAmount({
    this.incomeid,
    this.incomeAmount,
    this.date,
    this.description,
    this.paymenttype,
    this.userid,
    this.incomecategoryid,
  });

  factory IncomeAmount.fromJson(Map<String, dynamic> json) => IncomeAmount(
    incomeid: json['incomeid'], // Allow null if not present
    incomeAmount: (json["amount"] == null
        ? 0.00 // Handle null amount gracefully
        : (json["amount"] is String
        ? double.tryParse(json["amount"]) ?? 0.00 // Convert string to double
        : json["amount"] as double)), // Use directly if it's already a double
    date: json['date'] != null ? DateTime.tryParse(json['date']) : null, // Handle null date
    description: json['description'], // Allow null if not present
    paymenttype: json['paymenttype'], // Allow null if not present
    userid: json['userid'], // Allow null if not present
    incomecategoryid: json['incomecategoryid'], // Allow null if not present
  );

}
