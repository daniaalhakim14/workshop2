import 'dart:convert';
import 'package:tab_bar_widget/Model/Income_model.dart';
import 'package:tab_bar_widget/Model/InsightPage_model.dart';
import 'Income_Calling_API.dart';

class IncomeRepository {
  final CallingApi _service = CallingApi();

  Future<List<IncomeAmount>> getIncomeAmount(int userid) async {
    final response = await _service.fetchIncomeAmount(userid);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded Income amount List: $data');

      // Correctly map JSON list to `IncomeAmount` objects
      return (data as List).map((json) => IncomeAmount.fromJson(json)).toList();
    } else {
      print('API Error: ${response.body}');
      throw Exception('Failed to load income amount');
    }
  }


}

