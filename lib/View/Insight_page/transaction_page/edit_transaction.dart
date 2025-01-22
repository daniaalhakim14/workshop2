import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tab_bar_widget/Model/InsightPage_model.dart';

import '../../../ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import 'category_page.dart';
import 'incomeCategory_page.dart';



// Global Variable
const List<String> paymentType = <String>['Cash','Debit Card','Credit Card','Online Transfer','E-Wallet'];
// store the selected payment type
String dropdownValue = '';

class edit_transaction extends StatefulWidget {
  const edit_transaction({super.key, required this.userid,required this.transactionDetail});
  final int userid;
  final TransactionList transactionDetail;


  @override
  State<edit_transaction> createState() => _edit_transactionState();
}

class _edit_transactionState extends State<edit_transaction> {
  DateTime? selectedDate;
  late String todayDate = 'Today';
  late String yesterdayDate = 'Yesterday';
  late String textdate = todayDate;
  late var _textControllerAmount = TextEditingController();
  late var _textControllerAddNote = TextEditingController();
  Map<String, dynamic>? _selectedSubcategory_Category;


  @override
  void initState() {
    super.initState();

    // 1) Set up the selectedDate from the transaction
selectedDate = widget.transactionDetail.date?.toUtc().add(const Duration(hours: 8));


    // 2) Decide what text to show initially for the date
    if (selectedDate != null) {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      if (_isSameDay(selectedDate!, yesterday)) {
        textdate = yesterdayDate; // "Yesterday"
      } else if (_isSameDay(selectedDate!, now)) {
        textdate = todayDate; // "Today"
      } else {
        textdate = DateFormat('dd-MM-yyyy').format(selectedDate!);
      }
    } else {
      // If there's no date, just keep the default "Today"
      // or handle it however you prefer
      textdate = todayDate;
    }

    if (widget.transactionDetail.transactiontype == 'Expense') {
      // If we have subcategory info in the transactionDetail
      _selectedSubcategory_Category = {
        'subcategoryId': widget.transactionDetail.subcategoryid,
        'name': widget.transactionDetail.name,
        'icon': widget.transactionDetail.iconData,
        'color': widget.transactionDetail.iconColor,
      };
    } else {
      // For Income
      _selectedSubcategory_Category = {
        'incomeCategoryId': widget.transactionDetail.incomecategoryid,
        'name': widget.transactionDetail.name,
        'icon': widget.transactionDetail.iconData,
        'color': widget.transactionDetail.iconColor,
      };
    }

    // 3) Set up other fields
    double? amount = widget.transactionDetail.amount;
    _textControllerAmount = TextEditingController(
      text: amount != null ? amount.toStringAsFixed(2) : '',
    );

    _textControllerAddNote = TextEditingController(
      text: widget.transactionDetail.description ?? '',
    );

    dropdownValue = widget.transactionDetail.paymenttype ?? paymentType.first;


  }

// Helper method to check if two DateTime objects represent the same calendar day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(2.0),
              child: Column(
                  children: [
                    // btnCalender and enter transaction amount
                    Row(
                      children: [
                        // btnCalendar
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 10, right: 0),
                          child: SizedBox(
                            width: 122,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () async {
                                // set the calendar prefix
                                final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.utc(2000, 01, 01),
                                  lastDate: DateTime.utc(2100, 12, 31),
                                );
                                if (dateTime != null && !dateTime.isAfter(DateTime.now())) {
                                  setState(() {
                                    selectedDate = dateTime;

                                    // same logic
                                    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
                                    if (_isSameDay(dateTime, yesterday)) {
                                      textdate = yesterdayDate;
                                    } else if (_isSameDay(dateTime, DateTime.now())) {
                                      textdate = todayDate;
                                    } else {
                                      textdate = DateFormat('dd-MM-yyyy').format(dateTime);
                                    }
                                  });
                                } else {
                                  // show a message if the date is invalid
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select today\'s date or a past date.'),
                                    ),
                                  );
                                }
                              },
                              child: Text(textdate), // Display the date
                            ),
                          ),
                        ),
                        // enter transaction amount
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0, bottom: 0.0,left: 24.0,right: 13), // Adjusted padding
                            child: TextField(
                              controller: _textControllerAmount, // Ensure this is initialized
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'), // Restrict to two decimal places
                                ),
                              ],
                              onChanged: (value) {
                                // Dynamically handle input formatting if needed
                                setState(() {}); // Trigger UI update
                              },
                              style: TextStyle(
                                fontSize: 18,
                                color: widget.transactionDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    widget.transactionDetail.transactiontype == 'Expense' ? '-RM ' : '+RM ',
                                    style: TextStyle(
                                      color: widget.transactionDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                hintText: '0.00', // Simplified to match the desired behavior
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 18,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: widget.transactionDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                                    width: 2,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _textControllerAmount.clear();
                                    setState(() {}); // Clear and refresh UI
                                  },
                                  icon: const Icon(Icons.clear, size: 25.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Divider(
                        thickness: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                    // set Category column
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will space the elements apart
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if(widget.transactionDetail.transactiontype == 'Expense') {
                              final selectedSubcategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  CategoryPage(userid: widget.userid,),
                                ),
                              );
                              if (selectedSubcategory != null) {
                                setState(() {
                                  _selectedSubcategory_Category = selectedSubcategory; // to add to database and display the selected subcategory
                                });
                              }
                            }else{
                              final selectedIncomeCategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => incomeCategory_page(),
                                ),
                              );
                              if (selectedIncomeCategory != null) {
                                setState(() {
                                  _selectedSubcategory_Category = selectedIncomeCategory; // to add to database and display the selected subcategory
                                });
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 6, right: 10),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                  dashPattern: const [6, 3],
                                  borderType: BorderType.Circle,
                                  child: Container(
                                    width: 47,
                                    height: 47,
                                    decoration: BoxDecoration(
                                      color: _selectedSubcategory_Category != null
                                          ? _selectedSubcategory_Category!['color']
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    child: _selectedSubcategory_Category != null
                                        ? Center(
                                      child: Icon(
                                        _selectedSubcategory_Category?['icon'],
                                        size: 30,
                                      color: Colors.white,
                                      ),
                                    )
                                        : null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedSubcategory_Category != null
                                          ? _selectedSubcategory_Category!['name']
                                          : 'Set Category',
                                      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 22.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 30),
                      ],
                    ),
                    // add Notes column
                    Padding(padding: const EdgeInsets.only(top: 10.0,bottom: 8.0,left: 8,right: 10),
                      child:  Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.note_add_outlined, size: 50, color: Colors.black87),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 18, right: 0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 267,
                                      height: 48,
                                      child: TextField(
                                        controller: _textControllerAddNote,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: 'Add Notes',
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              _textControllerAddNote.clear();
                                            },
                                            icon: const Icon(Icons.clear),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Divider(
                        thickness: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                    // Payment type
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.5, right: 0),
                          child: Row(
                            children: [
                              const Icon(Icons.payment, size: 48, color: Colors.black87),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 17.5, right: 0),
                                child: Row(
                                  children: [
                                    const Text('Payment', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22.0)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Row(
                                          children: [
                                            DropdownButton<String>(
                                              value: dropdownValue,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down_outlined), elevation: 16,
                                              style: const TextStyle(color: Colors.deepPurple),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String? value){
                                                // this is called when the user selects an item.
                                                setState(() {
                                                  dropdownValue = value!;
                                                });
                                              },
                                              items: paymentType.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    width: 80, // Customize the width
                                                    height: 40, // Customize the height
                                                    alignment: Alignment.centerLeft, // Align text if needed
                                                    padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(fontSize: 11), // Customize text style
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ]
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // save change
                if(widget.transactionDetail.transactiontype == "Expense"){
                  print(widget.transactionDetail.userid);
                  print(selectedDate);
                  print(_textControllerAmount.text);
                  print(_selectedSubcategory_Category!['subcategoryId']);
                  print(_textControllerAddNote.text);
                  print(dropdownValue);

                  final viewModel = InsightViewModel();
                  UpdateExpense expense = UpdateExpense(
                    expenseId: widget.transactionDetail.transactionId!,
                    expenseAmount: double.parse(_textControllerAmount.text),
                    expenseDate: selectedDate,
                    expenseDescription:_textControllerAddNote.text,
                    paymentType: dropdownValue,
                    userId: widget.transactionDetail.userid,
                    subCategoryId: _selectedSubcategory_Category!['subcategoryId']

                  );try{
                    await viewModel.updateExpense(expense);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction Edited successfully!'),
                        duration: Duration(seconds: 2), // SnackBar will disappear after 2 seconds
                      ),
                    );
                    Navigator.pop(context, true); // Navigate back on success
                  }catch (e){
                    print("Failed to add Expense: $e");
                  }

                }else{
                  print(widget.transactionDetail.transactionId);
                  print(selectedDate);
                  print(_textControllerAmount.text);
                  print(_selectedSubcategory_Category!['incomeCategoryId']);
                  print(_textControllerAddNote.text);
                  print(dropdownValue);

                  final viewModel = InsightViewModel();
                  UpdateIncome income = UpdateIncome(
                      incomeId: widget.transactionDetail.transactionId!,
                      incomeAmount: double.parse(_textControllerAmount.text),
                      incomeDate: selectedDate,
                      incomeDescription:_textControllerAddNote.text,
                      paymentType: dropdownValue,
                      userId: widget.transactionDetail.userid,
                      incomeCategoryId: _selectedSubcategory_Category!['incomeCategoryId']

                  );try{
                    await viewModel.updateIncome(income);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction Edited successfully!'),
                        duration: Duration(seconds: 2), // SnackBar will disappear after 2 seconds
                      ),
                    );
                    Navigator.pop(context, true); // Navigate back on success
                  }catch (e){
                    print("Failed to add Expense: $e");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurpleAccent.shade100,
                  ),
                  width: 220.0,
                  height: 50.0,
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
