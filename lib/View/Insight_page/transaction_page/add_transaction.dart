import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../Model/InsightPage_model.dart';
import '../../../Model/SignupLoginPage_model.dart';
import '../../../ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import '../../../admin_dashboard/view_model/notification_vm.dart';
import '../../main_pages/insight_page.dart';
import 'category_page.dart';
import 'incomeCategory_page.dart';
import 'package:get/get.dart';


// Global Variable
const List<String> paymentType = <String>['Cash','Debit Card','Credit Card','Online Transfer','E-Wallet'];
// store the selected payment type
String dropdownValue = paymentType.first;



class add_transaction extends StatefulWidget {

  const add_transaction({super.key});

  @override
  State<add_transaction> createState() => _add_transactionState();
}

class _add_transactionState extends State<add_transaction> {
  int _selectedButtonIndex = 0; // dynamic latest and category button, 0 for Expense, for for Income
  Map<String, dynamic>? _selectedSubcategory_Category;
  late var _newTransactionType = 'Expense';



  DateTime selectedDate = DateTime.now(); // initial selected date
  late String todayDate = 'Today';
  late String yesterdayDate = 'Yesterday';
  late String textdate = todayDate;

  final _textControllerAddNote = TextEditingController();  // to store user input
  final _textControllerAmount = TextEditingController();



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(2.0),
              child: Column(
                  children: [
                    // syntax for expense income button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ // Expense Button
                      DynamicButton(
                        label: 'Expense',
                        color: _selectedButtonIndex == 0
                            ? const Color(0xFF65ADAD)
                            : Colors.grey,
                        onTap: () {
                          setState(() {
                            _selectedButtonIndex = 0;
                            _newTransactionType = 'Expense';  // to add to database
                            _selectedSubcategory_Category = null; // Reset the selected category
                          });
                          },
                        padding: const EdgeInsets.only(right:3.0),  // position button slightly to the right
                      ),
                    DynamicButton(
                      label: 'Income',
                      color: _selectedButtonIndex == 1
                          ? const Color(0xFF65ADAD)
                          : Colors.grey,
                      onTap: () {
                        setState(() {
                          _selectedButtonIndex = 1;
                          _newTransactionType = 'Income'; // to add to database
                          _selectedSubcategory_Category = null; // Reset the selected category
                        });
                        },
                      padding: const EdgeInsets.only(left:3.0),  // position button slightly to the left
                      ),
                  ],
                ),
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
                                    // Update `selectedDate` to the picked date
                                    selectedDate = dateTime;

                                    // Check if the date is yesterday
                                    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
                                    if (dateTime.year == yesterday.year &&
                                        dateTime.month == yesterday.month &&
                                        dateTime.day == yesterday.day) {
                                      textdate = yesterdayDate; // Set to 'Yesterday'
                                      selectedDate = yesterday;
                                    } else if (dateTime.year == DateTime.now().year && dateTime.month == DateTime.now().month && dateTime.day == DateTime.now().day) {
                                      textdate = todayDate; // Set to 'Today'
                                    } else {
                                      textdate = DateFormat('dd-MM-yyyy').format(dateTime); // Default date format
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
                                color: _selectedButtonIndex == 0 ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    _selectedButtonIndex == 0 ? '-RM ' : '+RM ',
                                    style: TextStyle(
                                      color: _selectedButtonIndex == 0 ? Colors.red : Colors.green,
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
                                    color: _selectedButtonIndex == 0 ? Colors.red : Colors.green,
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
                            if(_newTransactionType == 'Expense') {
                              final selectedSubcategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CategoryPage(),
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
                                      color: _selectedSubcategory_Category != null ? _selectedSubcategory_Category!['color'] : Colors.grey[300],
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
                                      _selectedSubcategory_Category != null ? _selectedSubcategory_Category!['name'] : 'Set Category',
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
        child: Column( // Add Transaction button
          children: [
            GestureDetector(
              onTap: () async {

                if(_newTransactionType == "Expense"){
                  print(_newTransactionType);
                  print(selectedDate);
                  print(_textControllerAmount.text);
                  print(_selectedSubcategory_Category!['subcategoryId']);
                  print(_textControllerAddNote.text);
                  print(dropdownValue);

                  final viewModel = InsightViewModel();
                  AddExpense expense = AddExpense(
                    expenseAmount: double.parse(_textControllerAmount.text),
                    expenseDate: selectedDate,
                    expenseDescription: _textControllerAddNote.text,
                    paymenttype: dropdownValue,
                    userid: 1,  // need to change later
                    subcategoryid: _selectedSubcategory_Category!['subcategoryId']
                  );
                  try {
                    await viewModel.addExpense(expense);
                    print("Expense added successfully!");
                    Navigator.pop(context,true); // Navigate back on success
                  } catch (e) {
                    print("Failed to add Expense: $e");
                  }

                  //add transaction alert based on subcategory
                  final NotificationViewModel notificationViewModel = Get.put(NotificationViewModel());
                  if (_selectedSubcategory_Category != null && _selectedSubcategory_Category!['subcategoryId'] != null) {
                    final String subcategoryId = _selectedSubcategory_Category!['subcategoryId'].toString();
                    try {
                      await notificationViewModel.checkSubcategoryBudget("13", subcategoryId); // need to change later to combine with user module
                      print("Notification added successfully!");
                    } catch (e) {
                      print("Failed to add Notification: $e");
                    }
                  } else {
                    print("Subcategory ID is null or invalid");
                  }

                  
                }else
                  {
                    print(_newTransactionType);
                    print(selectedDate);
                    print(_textControllerAmount.text);
                    print(_selectedSubcategory_Category!['incomeCategoryId']);
                    print(_textControllerAddNote.text);
                    print(dropdownValue);


                    final viewModel = InsightViewModel();
                    AddIncome income = AddIncome(
                        incomeAmount: double.parse(_textControllerAmount.text),
                        incomeDate: selectedDate,
                        incomeDescription: _textControllerAddNote.text,
                        paymenttype: dropdownValue,
                        userid: 1,  // need to change later
                        incomecategoryid: _selectedSubcategory_Category!['incomeCategoryId']
                    );
                    try {
                      await viewModel.addIncome(income);
                      print("income added successfully!");
                      Navigator.pop(context,true); // Navigate back on success
                    } catch (e) {
                      print("Failed to add Income: $e");
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
                  child: const Text('Add Transaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}

