// it means creating a data model that represents how a superhero
// is structured or organized in the application.
// This involves specifying the properties and types of data that each superhero should have (like name, realName, and imageUrl in this case).

import 'package:flutter/material.dart';


// data model to view expenses
class TransactionsExpense {
  final int? expenseid;
  final double? amount;
  final DateTime? date;
  final String? description;
  final String? paymenttype;
  final String? subcategoryname;
  final String? iconname; // Icon name from the `icon` table
  final IconData? icondata; // Combines `codepoint` and `fontfamily`
  final Color? iconcolor;
  final String? categoryname;
  final int? userid;

  TransactionsExpense({
    this.expenseid,
    this.amount,
    this.date,
    this.description,
    this.paymenttype,
    this.subcategoryname,
    this.iconname,
    this.icondata,
    this.iconcolor,
    this.categoryname,
    this.userid
  });
  // Factory constructor to create an instance from JSON
  factory TransactionsExpense.fromJson(Map<String, dynamic> json) => TransactionsExpense(
    expenseid: json['expenseid'],
    amount: json["amount"] is String
        ? double.tryParse(json["amount"]) // Convert string to double
        : json["amount"], // Use directly if it's already a double

    date: json["date"] != null
        ? DateTime.parse(json["date"]) // Parse ISO 8601 date strings
        : null,
    description: json["description"],
    paymenttype: json['paymenttype'],
    subcategoryname: json['subcategory_name'], // Matches SQL alias
    iconname: json['icon_name'], // Matches SQL alias
    icondata: (json['codepoint'] != null && json['fontfamily'] != null)
        ? IconData(
      json['codepoint'] is String
          ? int.tryParse(json['codepoint']) ?? 0 // Safely parse codepoint to int
          : json['codepoint'], // Use directly if it's already an int
      fontFamily: json['fontfamily'],
    )
        : null, // Create IconData if both codepoint and fontFamily are valid
    iconcolor: json['color'] != null
        ? Color(json['color'] is String
        ? int.tryParse(json['color']) ?? 0 // Safely parse color to int
        : json['color']) // Use directly if it's already an int
        : null, // Convert color integer to Color
    categoryname: json['category_name'],
    userid: json['userid'],
  );
}

class TransactionList{
  final int? transactionId;
  final double? amount;
  final DateTime? date;
  final String? name;
  final String? categoryname;
  final String? description;
  final String? paymenttype;
  final int? userid;
  final int? subcategoryid;
  final int? incomecategoryid;
  final String? transactiontype;
  final IconData? iconData;
  final Color? iconColor;

  TransactionList({
    this.transactionId,
    this.amount,
    this.date,
    this.name,  // name for subcategory and income category
    this.categoryname, //category name for expense
    this.description,
    this.paymenttype,
    this.userid,
    this.subcategoryid,
    this.incomecategoryid,
    this.transactiontype,
    this.iconData,
    this.iconColor
  });
  factory TransactionList.fromJson(Map<String, dynamic> json) => TransactionList(
    transactionId: json["transaction_id"],
    amount: json["amount"] == null
        ? null // Handle null amount gracefully
        : (json["amount"] is String
        ? double.tryParse(json["amount"]) // Convert string to double
        : json["amount"]), // Use directly if it's already a double
    date: json["date"] != null
        ? DateTime.tryParse(json["date"]) // Parse ISO 8601 date strings safely
        : null,
    name: json["subcategory_name"],
    categoryname: json["category_name"],
    description: json["description"],
    paymenttype: json["paymenttype"],
    userid: json["userid"],
    subcategoryid: json["subcategoryid"],
    incomecategoryid: json["incomecategoryid"],
    transactiontype: json["transaction_type"],
    iconData: (json['codepoint'] != null && json['fontfamily'] != null)
        ? IconData(
      json['codepoint'],
      fontFamily: json['fontfamily'],
    )
        : null,
    iconColor: json['color'] != null
        ? Color(int.tryParse(json['color']) ?? 0) // Safely parse the color string
        : null,
  );


  @override

  String toString() {
    return 'TransactionList(transactionId: $transactionId, amount: $amount, date: $date,'
        ' description: $description, paymenttype: $paymenttype, userid: $userid,'
        'subcategoryid: $subcategoryid,incomecategoryid: $incomecategoryid, transactiontype: $transactiontype,'
        'iconData: $iconData, iconColor: $iconColor  )';
  }
}

class BasicCategories {
  final int? categoryId;
  final String? categoryName;
  final int? iconId;
  final IconData? iconData;
  final Color? iconColor;

  BasicCategories({
    this.categoryId,
    this.categoryName,
    this.iconId,
    this.iconData,
    this.iconColor,
  });
  /*
  // Override toString to provide a meaningful representation in insight view model
  @override
  String toString() {
    return 'BasicCategories(categoryId: $categoryId, categoryName: $categoryName, iconId: $iconId, iconData: $iconData, iconColor: $iconColor)';
  }
   */
  factory BasicCategories.fromJson(Map<String, dynamic> json) => BasicCategories(
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    iconId: json["icon_id"],
    iconData: (json['code_point'] != null && json['font_family'] != null)
        ? IconData(
      json['code_point'],
      fontFamily: json['font_family'],
    )
        : null,
    iconColor: json['color'] != null
        ? Color(int.tryParse(json['color']) ?? 0) // Safely parse the color string
        : null,
  );
}

class IncomeCategories {
  final int? incomecategoryid;
  final String? categoryName;
  final int? iconId;
  final IconData? iconData;
  final Color? iconColor;

  IncomeCategories({
    this.incomecategoryid,
    this.categoryName,
    this.iconId,
    this.iconData,
    this.iconColor,
  });
  /*
  // Override toString to provide a meaningful representation in insight view model
  @override
  String toString() {
    return 'IncomeCategories(categoryId: $incomecategoryid, categoryName: $categoryName, iconId: $iconId, iconData: $iconData, iconColor: $iconColor)';
  }

   */
  factory IncomeCategories.fromJson(Map<String, dynamic> json) => IncomeCategories(
    incomecategoryid: json["incomecategory_id"], // Adjusted key
    categoryName: json["incomecategory_name"],  // Adjusted key
    iconId: json["icon_id"],
    iconData: (json['code_point'] != null && json['font_family'] != null)
        ? IconData(
      json['code_point'],
      fontFamily: json['font_family'],
    )
        : null,
    iconColor: json['color'] != null
        ? Color(int.tryParse(json['color']) ?? 0)
        : Colors.grey,
  );

}

class Subcategories{
  final int? subcategoryId;
  final String? subcategoryName;
  final int? parentCategoryId;
  final int? iconId;
  final IconData? iconData;
  final Color? iconColor;
  final int? userid;

  Subcategories({
    this.subcategoryId,
    this.subcategoryName,
    this.parentCategoryId,
    this.iconId,
    this.iconData,
    this.iconColor,
    this.userid,
  });


  factory Subcategories.fromJson(Map<String,dynamic> json) => Subcategories(
    subcategoryId: json["subcategory_id"],
    subcategoryName: json["subcategory_name"],
    parentCategoryId: json["parentcategoryid"],
    iconId: json["iconid"],
    iconData: (json['codepoint'] != null && json['fontfamily'] != null)
        ? IconData(
      json['codepoint'],
      fontFamily: json['fontfamily'],
    )
        : null,
    iconColor: json['color'] != null
        ? Color(int.tryParse(json['color']) ?? 0) // Safely parse the color string
        : null,
    userid: json['userid']
  );
  /*
  // Override toString for better debugging
  @override
  String toString() {
    return 'Subcategory(subcategoryName: $subcategoryName, iconid: $iconId, parentCategoryId: $parentCategoryId, iconData: $iconData, iconColor: $iconColor)';
  }

   */

}

class AddSubcategories {
  final int? userid;
  final String? newSubcategoryName;
  final int? parentCategoryId;
  final int? iconId;

  AddSubcategories({
    this.userid,
    this.newSubcategoryName,
    this.parentCategoryId,
    this.iconId,
  });

  factory AddSubcategories.fromJson(Map<String, dynamic> json) => AddSubcategories(
    userid: json['userid'],
    newSubcategoryName: json["subcategory_name"],
    parentCategoryId: json["parentcategoryid"],
    iconId: json["iconid"],
  );

  Map<String, dynamic> toMap() {
    return {
      "userid": userid,
      "subcategory_name": newSubcategoryName,
      "parentcategoryid": parentCategoryId,
      "iconid": iconId,
    };
  }
}

class AddExpense {
  final double? expenseAmount;
  final DateTime? expenseDate;
  final String? expenseDescription;
  final String? paymenttype;
  final int? userid;
  final int? subcategoryid;

  AddExpense({
    this.expenseAmount,
    this.expenseDate,
    this.expenseDescription,
    this.paymenttype,
    this.userid,
    this.subcategoryid,
  });

  factory AddExpense.fromJson(Map<String, dynamic> json) => AddExpense(
    expenseAmount: json["amount"],
    expenseDate: DateTime.parse(json["date"]), // Parse string to DateTime
    expenseDescription: json["description"],
    paymenttype: json["paymenttype"],
    userid: json["userid"],
    subcategoryid: json["subcategoryid"]

  );

  Map<String, dynamic> toMap() {
    return {
      "amount": expenseAmount,
      "date": expenseDate?.toIso8601String(), // Convert DateTime to string
      "description": expenseDescription,
      "paymenttype": paymenttype,
      "userid": userid,
      "subcategoryid":subcategoryid
    };
  }
  @override
  String toString() {
    return 'AddExpense(amount: $expenseAmount, date: $expenseDate, description: $expenseDescription, '
        'paymenttype: $paymenttype, userid: $userid, subcategoryid: $subcategoryid)';
  }
}

class AddIncome {
  final double? incomeAmount;
  final DateTime? incomeDate;
  final String? incomeDescription;
  final String? paymenttype;
  final int? userid;
  final int? incomecategoryid;

  AddIncome({
    this.incomeAmount,
    this.incomeDate,
    this.incomeDescription,
    this.paymenttype,
    this.userid,
    this.incomecategoryid,
  });

  factory AddIncome.fromJson(Map<String, dynamic> json) => AddIncome(
      incomeAmount: json["amount"],
      incomeDate: DateTime.parse(json["date"]), // Parse string to DateTime
      incomeDescription: json["description"],
      paymenttype: json["paymenttype"],
      userid: json["userid"],
      incomecategoryid: json["incomecategoryid"]

  );

  Map<String, dynamic> toMap() {
    return {
      "amount": incomeAmount,
      "date": incomeDate?.toIso8601String(), // Convert DateTime to string
      "description": incomeDescription,
      "paymenttype": paymenttype,
      "userid": userid,
      "incomecategoryid":incomecategoryid
    };
  }
}

class AddIcon {
  final String? name;
  final IconData? iconId;
  final int? codePoint;
  final String? fontFamily;
  final Color? color;

  AddIcon({
    this.name,
    this.iconId,
    this.codePoint,
    this.fontFamily,
    this.color,
  });
  // Convert an AddIcon instance to a map for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'codePoint': codePoint,
      'fontFamily': fontFamily,
      'color': color?.value, // Store color as an integer
    };
  }
  // Create an AddIcon instance from a JSON map
  factory AddIcon.fromJson(Map<String, dynamic> json) {
    return AddIcon(
      name: json['name'],
      iconId: json['iconid'],
      codePoint: json['codePoint'],
      fontFamily: json['fontFamily'],
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }
}

class UpdateExpense {
  final int expenseId;           // The ID of the expense you are updating
  final double? expenseAmount;
  final DateTime? expenseDate;
  final String? expenseDescription;
  final String? paymentType;
  final int? userId;
  final int? subCategoryId;

  UpdateExpense({
    required this.expenseId,     // Mark as required since you need it for updates
    this.expenseAmount,
    this.expenseDate,
    this.expenseDescription,
    this.paymentType,
    this.userId,
    this.subCategoryId,
  });

  // Construct an UpdateExpense from JSON
  factory UpdateExpense.fromJson(Map<String, dynamic> json) {
    return UpdateExpense(
      expenseId: json["id"],
      expenseAmount: json["amount"],
      expenseDate: json["date"] != null ? DateTime.parse(json["date"]) : null,
      expenseDescription: json["description"],
      paymentType: json["paymenttype"],
      subCategoryId: json["subcategoryid"],
    );
  }

  // Convert UpdateExpense object to a Map for JSON or DB updates
  Map<String, dynamic> toMap() {
    return {
      "id": expenseId,
      "amount": expenseAmount,
      "date": expenseDate?.toIso8601String(),
      "description": expenseDescription,
      "paymenttype": paymentType,
      "userid": userId,
      "subcategoryid": subCategoryId,
    };
  }
}

class UpdateIncome {
  final int incomeId;           // The ID of the expense you are updating
  final double? incomeAmount;
  final DateTime? incomeDate;
  final String? incomeDescription;
  final String? paymentType;
  final int? userId;
  final int? incomeCategoryId;

  UpdateIncome({
    required this.incomeId,     // Mark as required since you need it for updates
    this.incomeAmount,
    this.incomeDate,
    this.incomeDescription,
    this.paymentType,
    this.userId,
    this.incomeCategoryId,
  });

  // Construct an UpdateExpense from JSON
  factory UpdateIncome.fromJson(Map<String, dynamic> json) {
    return UpdateIncome(
      incomeId: json["id"],
      incomeAmount: json["amount"],
      incomeDate: json["date"] != null ? DateTime.parse(json["date"]) : null,
      incomeDescription: json["description"],
      paymentType: json["paymenttype"],
      incomeCategoryId: json["incomecategoryid"],
    );
  }

  // Convert UpdateExpense object to a Map for JSON or DB updates
  Map<String, dynamic> toMap() {
    return {
      "id": incomeId,
      "amount": incomeAmount,
      "date": incomeDate?.toIso8601String(),
      "description": incomeDescription,
      "paymenttype": paymentType,
      "userid": userId,
      "incomecategoryid": incomeCategoryId,
    };
  }
}

class DeleteExpense {
  final int expenseId; // The ID of the expense to be deleted

  DeleteExpense({
    required this.expenseId,
  });

  // Construct a DeleteExpense instance from JSON
  factory DeleteExpense.fromJson(Map<String, dynamic> json) {
    return DeleteExpense(
      expenseId: json["id"],
    );
  }

  // Convert DeleteExpense object to a Map for API requests
  Map<String, dynamic> toMap() {
    return {
      "id": expenseId,
    };
  }
}

class DeleteIncome {
  final int incomeId; // The ID of the expense to be deleted

  DeleteIncome({
    required this.incomeId,
  });

  // Construct a DeleteExpense instance from JSON
  factory DeleteIncome.fromJson(Map<String, dynamic> json) {
    return DeleteIncome(
      incomeId: json["id"],
    );
  }

  // Convert DeleteExpense object to a Map for API requests
  Map<String, dynamic> toMap() {
    return {
      "id": incomeId,
    };
  }
}


