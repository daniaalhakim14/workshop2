// Service class
import 'dart:convert';
import 'package:http/http.dart'as http;
import '../../configure_API.dart';

class CallingApi{
// Indicates that the function is asynchronous and does not return a value.
// Instead, it returns a Future, which represents a potential value or error that will be available at some point in the future.

final http.Client _httpClient = http.Client();

  Future<http.Response> fetchTransactionsExpense(int userid) async{
    // change to Expense
    String endpoint = '/expense/$userid';
    String url = '${AppConfig.baseUrl}$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchTransactionList(int userid) async{
    // change to Expense
    String endpoint = '/transactions/$userid';
    String url = '${AppConfig.baseUrl}$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchBasicCategories() async{
    String endpoint = '/categories';
    String url = '${AppConfig.baseUrl}$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchIncomeCategories() async{
    String endpoint = '/incomeCategories';
    String url = '${AppConfig.baseUrl}$endpoint';
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> fetchSubcategories(int parentCategoryId, int? userid) async{
      String endpoint = '/subcategories/basic/$parentCategoryId/$userid';
    String url = '${AppConfig.baseUrl}$endpoint';
    return await http.get(Uri.parse(url));
  }
  /*
  Future<http.Response> fetchSubcategoriesForUser(int parentCategoryId, int userid) async{
      String endpoint = '/subcategories/$parentCategoryId/custom/$userid';
      String url = '${AppConfig.baseUrl}$endpoint';
      return await http.get(Uri.parse(url));
    }

   */

  Future<http.Response> addIcon(Map<String, dynamic> iconData) async {
    String endpoint = '/icons';
    String url = '${AppConfig.baseUrl}$endpoint';

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

  Future<http.Response> addSubcategories(Map<String, dynamic> subcategoryData, int userId) async {
  // Adjust endpoint to include both id and userId
  String endpoint = '/subcategories/${subcategoryData["parentcategoryid"]}/$userId';
  String url = '${AppConfig.baseUrl}$endpoint';

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
    String url = '${AppConfig.baseUrl}$endpoint';

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
    String url = '${AppConfig.baseUrl}$endpoint';

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
  String url = '${AppConfig.baseUrl}$endpoint';

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
    String url = '${AppConfig.baseUrl}$endpoint';

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

  Future<http.Response> deleteExpense(int expenseId, int userid) async {
    String endpoint = '/expense/$expenseId/$userid';
    String url = '${AppConfig.baseUrl}$endpoint';

    print("Deleting expense with ID: $expenseId");

    final response = await http.delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response;
  }

  Future<http.Response> deleteIncome(int incomeId, int userid) async {
    String endpoint = '/income/$incomeId/$userid';
    String url = '${AppConfig.baseUrl}$endpoint';

    print("Deleting income with ID: $incomeId");

    final response = await http.delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response;
  }

// Add a dispose method to clean up
void dispose() {
  _httpClient.close(); // Close the HTTP client to release resources
  print("HTTP client closed.");
}

}
