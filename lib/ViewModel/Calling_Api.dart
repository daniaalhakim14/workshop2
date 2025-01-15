// Service class
import 'dart:convert';

import 'package:http/http.dart'as http;

class CallingApi{
// Indicates that the function is asynchronous and does not return a value.
// Instead, it returns a Future, which represents a potential value or error that will be available at some point in the future.
  final String baseUrl = 'http://192.168.0.12:3000';

  Future<http.Response> fetchTransactionsExpense() async{
    // change to Expense
    String endpoint = '/expense';
    String url = '$baseUrl$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchTransactionList() async{
    // change to Expense
    String endpoint = '/transactions';
    String url = '$baseUrl$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchBasicCategories() async{
    String endpoint = '/categories';
    String url = '$baseUrl$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchIncomeCategories() async{
    String endpoint = '/incomeCategories';
    String url = '$baseUrl$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchSubcategories(int parentCategoryId) async{
    String endpoint = '/subcategories/$parentCategoryId';
    String url = '$baseUrl$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> addIcon(Map<String, dynamic> iconData) async {
    String endpoint = '/icons';
    String url = '$baseUrl$endpoint';

    print("Sending icon data: $iconData"); // Log the data being sent

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(iconData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Log the response body

    return response;
  }

  Future<http.Response> addSubcategories(Map<String, dynamic> subcategoryData) async {
    String endpoint = '/subcategories';
    String url = '$baseUrl$endpoint';

    print("Sending subcategory data: $subcategoryData"); // Log the data being sent

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(subcategoryData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Log the response body

    return response;
  }

  Future<http.Response> addExpense(Map<String, dynamic> expenseData) async {
    // change to Expense
    String endpoint = '/expense'; // Update this to match your API endpoint
    String url = '$baseUrl$endpoint';

    print("Sending transaction data: $expenseData"); // Log the data being sent

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expenseData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Log the response body

    return response;
  }

  Future<http.Response> addIncome(Map<String, dynamic> incomeData) async {
    // change to Expense
    String endpoint = '/income'; // Update this to match your API endpoint
    String url = '$baseUrl$endpoint';

    print("Sending transaction data: $incomeData"); // Log the data being sent

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incomeData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Log the response body

    return response;
  }

  Future<http.Response> updateExpense(int expenseId, Map<String, dynamic> expenseData) async {
  String endpoint = '/expense/$expenseId'; // Ensure this matches your API endpoint
  String url = '$baseUrl$endpoint';

  print("Sending update data: $expenseData"); // Log the data being sent

  final response = await http.put(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(expenseData),
  );

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}"); // Log the response body

  return response;
  }

  Future<http.Response> updateIncome(int incomeId, Map<String, dynamic> incomeData) async {
    String endpoint = '/income/$incomeId'; // Ensure this matches your API endpoint
    String url = '$baseUrl$endpoint';

    print("Sending update data: $incomeData"); // Log the data being sent

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incomeData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Log the response body

    return response;
  }

  Future<http.Response> deleteExpense(int expenseId) async {
    String endpoint = '/expense/$expenseId';
    String url = '$baseUrl$endpoint';

    print("Deleting expense with ID: $expenseId");

    final response = await http.delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response;
  }

  Future<http.Response> deleteIncome(int incomeId) async {
    String endpoint = '/income/$incomeId';
    String url = '$baseUrl$endpoint';

    print("Deleting income with ID: $incomeId");

    final response = await http.delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response;
  }




}
