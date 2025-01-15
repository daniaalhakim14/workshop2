import 'package:flutter/cupertino.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';

class DateViewModel extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {

    DateTime? picked = await showMonthYearPicker(
      context: context,
      firstDate: DateTime(selectedDate.year - 3),
      lastDate: DateTime(selectedDate.year + 3),
      initialDate: selectedDate, // Set initial date
    );

    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  void setSelectedDate(String dateString) {
    // Split the string into month and year
    List<String> parts = dateString.split(' ');
    int month = int.parse(parts[0]); // Parse the month
    int year = int.parse(parts[1]);   // Parse the year

    // Create a DateTime object (defaulting to the first day of the month)
    DateTime dateTime = DateTime(year, month);

    selectedDate = dateTime;
    notifyListeners();
  }

  String get formattedSelectedDate => DateFormat('MMMM yyyy').format(selectedDate);

  String get yearMonthDay => DateFormat('yyyy-MM-dd').format(selectedDate);
}