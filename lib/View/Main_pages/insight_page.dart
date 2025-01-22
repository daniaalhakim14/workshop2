import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../Model/InsightPage_model.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../../ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import '../../ViewModel/app_appearance_viewmodel.dart';
import '../Insight_page/analysis_page/analysis_tab_page.dart';
import '../Insight_page/transaction_page/CategoryDetailScreen.dart';
import '../Insight_page/transaction_page/TransactionDetailScreen.dart';
import '../Insight_page/transaction_page/add_transaction.dart';
import 'account_page.dart';
import 'dart:async';
import 'homepage.dart';
import 'notification_page.dart';
import '../Insight_page/budget_pages/budget_tab_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_bar_widget/configure_API.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// configure daily spent and spent so far

class Insight extends StatefulWidget {
  final UserInfoModule userInfo; // Accept UserModel as a parameter
  const Insight({super.key,required this.userInfo});

  @override
  State<Insight> createState() => _InsightState();
}

class _InsightState extends State<Insight> with SingleTickerProviderStateMixin {
  bool showDailySpending = true;    // Variable to toggle between daily spent and spent so far
  List<DateTime> months = []; // Declare list months and initialise to months to be empty
  String selectedMonth = "";  // Declare variable selectedMonth to store selectedMonth
  late ScrollController _scrollController;
  late Timer _timer;
  int _selectedButtonIndex = 0; // 0 for 'Latest', 1 for 'Category'


  @override
  void initState() {  // to set initial state when insight page is executed
    super.initState();
    _scrollController = ScrollController(); // instance created to manage horizontal behavior of the months Listview
    _initializeMonths();
    selectedMonth = _formatMonth(DateTime.now()); // Default selected month is the current month
    //addIconExample();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<InsightViewModel>(context, listen: false);
      if (!viewModel.fetchingData && viewModel.transactionsExpense.isEmpty) {
        viewModel.fetchTransactionsExpense(widget.userInfo.id);
      }

    });

    // Start a timer to check for month changes
    _startMonthCheckTimer();
  }

  void _initializeMonths() {  // Populates list with the past 12 months, starting from current months
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      months.add(DateTime(now.year, now.month - i));
    }
    months = months.reversed.toList(); // Reverse the order to show the newest months
  }

  void _startMonthCheckTimer() {
    _timer = Timer.periodic(Duration(hours: 1), (_) {
      DateTime now = DateTime.now();
      if (!_isMonthInList(now)) {
        _updateMonths();
      }
    });
  }

  bool _isMonthInList(DateTime now) {
    String currentMonthFormatted = _formatMonth(now);
    return months.any((month) => _formatMonth(month) == currentMonthFormatted);
  }

  void _updateMonths() {  //  checks hourly if a new month has arrived. Updates the months list by removing the oldest month and adding the next month
    setState(() {
      months.removeAt(0); // Remove the first (oldest) month
      DateTime lastMonth = months.last;
      months.add(DateTime(lastMonth.year, lastMonth.month + 1)); // Add the next month
    });
  }

  void scrollToMonth(String month) {  // this methods automatically scrolls to selected months
    int index = months.indexWhere((date) => _formatMonth(date) == month);
    if (index != -1) {
      double offset = index * 90.0; // Adjust offset based on item width and padding
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _formatMonth(DateTime date) {
  DateTime malaysiaTime = date.toUtc().add(Duration(hours: 8));
  return "${_monthNamePieChart(malaysiaTime.month)} ${malaysiaTime.year}";
  }


  String _monthNamePieChart(int month) {
    const monthNames = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    return monthNames[month - 1];
  }

  String _monthNameTransactionList(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return monthNames[month - 1];
  }


  String _formatFullDate(DateTime date) {
      // Convert to Malaysia time by adding 8 hours
    DateTime malaysiaTime = date.toUtc().add(Duration(hours: 8));
    return "${malaysiaTime.day.toString().padLeft(2, '0')} ${_monthNameTransactionList(malaysiaTime.month)} ${malaysiaTime.year}";
  }


  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFF65ADAD),
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black, // Back arrow color
          ),
          title: Center(
            child: Text(
              'Insight',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Budget'),
                Tab(text: 'Transaction'),
                Tab(text: 'Analysis'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  budget(userInfo: widget.userInfo),
                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            children: [
                              // Fetch Data from database
                              Consumer<InsightViewModel>(
                                builder: (context, viewModel, child) {
                                  if (viewModel.fetchingData) {
                                    return Container(
                                        width: 250,
                                        height: 250,
                                        child: const Center(child: CircularProgressIndicator()));
                                  }
                                  if (viewModel.transactionsExpense.isEmpty) {
                                    return Column(
                                      children: [
                                        Image.asset(
                                          'lib/Icons/statistics (2).png',
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 20),
                                        const Center(
                                          child: Text(
                                            'No Transaction Made',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  // to display expense pie graph
                                  // Step 1: Aggregate data by categoryname
                                  final Map<String, double> aggregatedData = {};
                                  final Map<String, Color> categoryColors = {};
                                  final Map<String, IconData> categoryIcons = {};
                                  double totalAmount = 0.0;

                                  // date conversion
                                  for (var expense in viewModel.transactionsExpense) {
                                    String isoFormatDate = expense.date.toString();
                                    DateTime dateTime = DateTime.parse(isoFormatDate);
                                    String formattedExpenseDate = _formatMonth(dateTime); // Format expense.date

                                    if (expense.categoryname != null && formattedExpenseDate == selectedMonth && expense.userid == widget.userInfo.id) {
                                      if (!aggregatedData.containsKey(expense.categoryname)) {
                                        aggregatedData[expense.categoryname!] = 0.0;
                                        categoryColors[expense.categoryname!] = expense.iconcolor!;
                                        categoryIcons[expense.categoryname!] = expense.icondata!;
                                      }
                                      aggregatedData[expense.categoryname!] =
                                          aggregatedData[expense.categoryname!]! +
                                              (expense.amount ?? 0.0);

                                      totalAmount += (expense.amount ?? 0.0); // Sum up total expenses
                                    }
                                  }

                                  // Check if there's any data to display
                                  if (aggregatedData.isEmpty) {
                                    return Column(
                                      children: [
                                        Image.asset(
                                          'lib/Icons/statistics (2).png',
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 20),
                                        Center(
                                          child: Text(
                                            "No expense data for $selectedMonth",
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(height: 10) // for spacing
                                      ],
                                    );
                                  }

                                  // Step 2: Calculate daily average spending
                                  DateTime now = DateTime.now();
                                  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
                                  int daysPassed = now.difference(firstDayOfMonth).inDays + 1; // Add 1 to include the current day
                                  double dailyAverageSpending = totalAmount / daysPassed;

                                  // Step 3: Calculate total and percentages for pie chart
                                  final List<PieChartSectionData> sections = aggregatedData.entries.map((entry) {
                                    final category = entry.key;
                                    final amount = entry.value;
                                    final percentage = (amount / totalAmount) * 100;
                                    // Set a minimum percentage threshold
                                    final adjustedPercentage = percentage < 0.01 ? 0.01 : percentage;
                                    // Adjust the radius and badge size dynamically
                                    final segmentRadius = adjustedPercentage < 1 ? 20.0 : 36.0; // Smaller radius for small percentages
                                    final badgeSize = adjustedPercentage < 1 ? 16.0 : 24.0; // Smaller badge size for small percentages
                                    // Enter data in pie chart
                                    return PieChartSectionData(
                                      value: adjustedPercentage,
                                      color: categoryColors[category], // Use color associated with the category
                                      title: adjustedPercentage < 1 ? '' : '${adjustedPercentage.toStringAsFixed(1)}%', // Hide title for very small segments
                                      radius: segmentRadius,
                                      titleStyle: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      badgeWidget: adjustedPercentage < 1
                                          ? null // No badge for very small segments
                                          : Icon(
                                        categoryIcons[category],
                                        color: categoryColors[category],
                                        size: badgeSize,
                                      ),
                                      badgePositionPercentageOffset: 1.38, // Position badges outside
                                    );
                                  }).toList();
                                  // To display Pie chart
                                  return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 300, // Set a fixed height
                                          //color: Colors.blue,
                                          child: PieChart(
                                            duration: const Duration(milliseconds: 1500),
                                            //curve: Curves.easeInOutQuint,
                                            PieChartData(
                                              sections: sections,
                                              borderData: FlBorderData(show: false),
                                              sectionsSpace: 2,
                                              centerSpaceRadius: 75,
                                            ),
                                          ),
                                        ),
                                        // To show Daily Avg Spending and Spent So far
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.arrow_upward,color: Colors.black,),
                                              onPressed: () {
                                                setState(() {
                                                  showDailySpending = true;
                                                });
                                              },
                                            ),
                                            Text(
                                              showDailySpending
                                                  ? "Daily Average Spending"
                                                  : "Spent So Far",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              showDailySpending ? "RM ${dailyAverageSpending.toStringAsFixed(2)}" : "RM ${totalAmount.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.arrow_downward,color: Colors.black,),
                                              onPressed: () {
                                                setState(() {
                                                  showDailySpending = false;
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ]
                                  );
                                },
                              ),
                              // Horizontal scroll months syntax
                              Center(
                                child: Column(
                                  children: [
                                    // Horizontal scrollable months
                                    SizedBox(
                                      height: 40,
                                      child: ListView.builder(  // creates a horizontal scrollable list of months
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: months.length,
                                        itemBuilder: (context, index) {

                                          if (index == 0) {
                                            // Scroll to selected month when ListView is built
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              if (_scrollController.hasClients) {
                                                scrollToMonth(selectedMonth);
                                              }
                                            });
                                          }

                                          final month = months[index];
                                          final monthString = _formatMonth(month);
                                          final isSelected = monthString == selectedMonth;

                                          return GestureDetector( // lets users select a month
                                            onTap: () {
                                              setState(() {
                                                selectedMonth = monthString;
                                              });
                                              scrollToMonth(monthString);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    monthString,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                      color: isSelected ? Colors.black : Colors.grey,
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    Container(
                                                      width: 30,
                                                      height: 2,
                                                      color: Colors.black,
                                                      margin: const EdgeInsets.only(top: 4),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Latest and Category Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 'Latest' button
                                  DynamicButton(
                                    label: 'Latest',
                                    color: _selectedButtonIndex == 0
                                        ? const Color(0xFF65ADAD)
                                        : Colors.grey,
                                    onTap: () {
                                      setState(() {
                                        _selectedButtonIndex = 0;
                                      });
                                      print("Latest button tapped!");
                                    },
                                    padding: const EdgeInsets.only(right: 3.0), // position button slightly to the right
                                  ),
                                  // 'Category' button
                                  DynamicButton(
                                    label: 'Category',
                                    color: _selectedButtonIndex == 1
                                        ? const Color(0xFF65ADAD)
                                        : Colors.grey,
                                    onTap: () {
                                      setState(() {
                                        _selectedButtonIndex = 1;
                                      });
                                      print("Category button tapped!");
                                    },
                                    padding: const EdgeInsets.only(left: 3.0),
                                  ),
                                ],
                              ),
                              // to add space
                              const SizedBox(height: 18),
                              // To display transaction list
                              _selectedButtonIndex == 0
                                  ? Consumer<InsightViewModel>(
                                builder: (context, viewModel, child) {
                                  final viewModel = Provider.of<InsightViewModel>(context, listen: false);
                                  List<TransactionList> transactionList = viewModel.transactionList;

                                  if (viewModel.fetchingData) {
                                    return Container(
                                      width: 250,
                                      height: 250,
                                      child: const Center(child: CircularProgressIndicator()),
                                    );
                                  }

                                  // Filter transactions by the selected month
                                  final filteredTransactions = transactionList.where((transaction) {
                                    String isoFormatDate = transaction.date.toString();
                                    DateTime dateTime = DateTime.parse(isoFormatDate);
                                    String formattedDate = _formatMonth(dateTime); // Format transaction.date
                                    return formattedDate == selectedMonth;
                                  }).toList();

                                  if (filteredTransactions.isEmpty) {
                                    return Column(
                                      children: [
                                        Image.asset(
                                          'lib/Icons/statistics (2).png',
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 20),
                                        Center(
                                          child: Text(
                                            'No transactions for $selectedMonth',
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.43,
                                    child: ListView.builder(
                                      itemCount: filteredTransactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction = filteredTransactions[index];

                                        String isoFormatDate = transaction.date.toString();
                                        DateTime dateTime = DateTime.parse(isoFormatDate);
                                        String formattedDate = _formatFullDate(dateTime); // Format transaction.date

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TransactionDetailScreen(
                                                  userid: widget.userInfo.id,
                                                  listDetail: transaction, // Pass the single transaction object
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              // List Header
                                              if (index == 0 || filteredTransactions[index - 1].date != transaction.date)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                  ),
                                                  height: 30.0,
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(
                                                      formattedDate, // Display the transaction date
                                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),

                                              // Transaction Details
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey, // Border color
                                                    width: 1.0,         // Border width
                                                  ),
                                                  borderRadius: BorderRadius.circular(0.0), // Optional: Rounded corners
                                                ),
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor: transaction.iconColor,
                                                    child: Icon(
                                                      transaction.iconData,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    transaction.name.toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: isDarkMode ? Colors.white : Colors.black, // Dynamic color based on dark mode
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        transaction.description.toString(),
                                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text(
                                                      'RM ${transaction.amount}', // Format the amount
                                                      style: TextStyle(
                                                        color: isDarkMode ? Colors.white : Colors.grey[800], // Dynamic color
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );

                                },
                              )
                                  : Consumer<InsightViewModel>(
                                builder: (context, viewModel, child) {
                                  final viewModel = Provider.of<InsightViewModel>(context, listen: false);
                                  List<TransactionList> categoryList = viewModel.transactionList;

                                  if (viewModel.fetchingData) {
                                    return Container(
                                      width: 250,
                                      height: 250,
                                      child: const Center(child: CircularProgressIndicator()),
                                    );
                                  }

                                  // Filter transactions by the selected month
                                  final filteredCategories = categoryList.where((categories) {
                                    String isoFormatDate = categories.date.toString();
                                     DateTime dateTime = DateTime.parse(isoFormatDate).toUtc().add(Duration(hours: 8));
                                    String formattedDate = _formatMonth(dateTime); // Format transaction.date
                                    return formattedDate == selectedMonth;
                                  }).toList();

                                  if (filteredCategories.isEmpty) {
                                    return Column(
                                      children: [
                                        Image.asset(
                                          'lib/Icons/statistics (2).png',
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 20),
                                        Center(
                                          child: Text(
                                            'No transactions for $selectedMonth',
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  // Group by category and aggregate transactions
                                  final Map<String, List<TransactionList>> groupedCategories = {};
                                  for (var transaction in filteredCategories) {
                                    // Only include transactions that are 'Expense'
                                    if (transaction.transactiontype == 'Expense') {
                                      groupedCategories.putIfAbsent(transaction.categoryname ?? 'Other', () => []);
                                      groupedCategories[transaction.categoryname ?? 'Other']!.add(transaction);
                                    }
                                  }

                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.43,
                                    child: ListView.builder(
                                      itemCount: groupedCategories.keys.length,
                                      itemBuilder: (context, index) {
                                        final categoryName = groupedCategories.keys.toList()[index];
                                        final categoryTransactions = groupedCategories[categoryName]!;
                                        final totalAmount = categoryTransactions.fold<double>(
                                          0,
                                              (sum, transaction) => sum + (transaction.amount ?? 0),
                                        );

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CategoryDetailScreen(
                                                    userid: widget.userInfo.id,
                                                    categoryName: categoryName, // Pass the category name
                                                    categoryTransactions: groupedCategories[categoryName]!, // Pass the transactions for this category
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey, // Border color
                                                        width: 1.0,         // Border width
                                                      ),
                                                      borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
                                                    ),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor: categoryTransactions.first.iconColor,
                                                        child: Icon(
                                                          categoryTransactions.first.iconData,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        categoryName,
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      subtitle: Text(
                                                        '${categoryTransactions.length} Transaction${categoryTransactions.length > 1 ? 's' : ''}', // Display transaction count
                                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                      ),
                                                      trailing: Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Text(
                                                          '-RM ${totalAmount.toStringAsFixed(2)}', // Display total amount
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 0.0), // Add spacing between items
                                              ],
                                            )
                                        );
                                      },
                                    ),
                                  );

                                },
                              )

                            ],
                          ),
                        ),
                      ),
                      // Manually positioned FloatingActionButton.extended
                      Positioned(
                        bottom: 16.0,
                        left: 0.0,
                        right: 0.0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  add_transaction(userid: widget.userInfo.id),
                                ),
                              );
                              // If a new transaction was added, refresh the list
                              if (result == true) {
                                print("Refreshing transaction list...");
                                final viewModel = Provider.of<InsightViewModel>(context, listen: false);
                                viewModel.fetchTransactionsExpense(widget.userInfo.id); // Fetch the latest transactions
                                viewModel.fetchTransactionList(widget.userInfo.id);
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Transaction'),
                          ),
                        ),
                      ),

                    ]
                  ),
                  Analysis(userInfo: widget.userInfo),
                ],
              ),
            ),
          ],
        ),



        bottomNavigationBar: BottomAppBar(
          color: isDarkMode ? Colors.black : const Color(0xFF002B36),
          child: _bottomBarConfiguration(context,widget.userInfo),
        ),
      ),
    );
  }
}

Row _bottomBarConfiguration(BuildContext context, UserInfoModule userInfo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userInfo: userInfo),
            ),
          );
        },
        icon: const Icon(
          Icons.home_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Image.asset(
          'lib/Icons/three lines.png',
          height: 30,
          width: 30,
          color: const Color(0xFF65ADAD),
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Noti(userInfo: userInfo), // Updated
            ),
          );
        },
        icon: Image.asset(
          'lib/Icons/notification.png',
          height: 30,
          width: 30,
          color: Colors.white,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Account(userInfo: userInfo), // Updated
            ),
          );
        },
        icon: Image.asset(
          'lib/Icons/safe.png',
          height: 30,
          width: 30,
          color: Colors.white,
        ),
      ),
    ],
  );
}

class DynamicButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const DynamicButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.width = 110.0,
    this.height = 35.0,
    this.margin = const EdgeInsets.all(10.0),
    this.padding = const EdgeInsets.all(3.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(20.0)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;////
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : color, // Dynamic background color
            borderRadius: borderRadius,
          ),
          margin: margin,
          width: width,
          height: height,
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// not using
void addIconExample() async {
  final viewModel = InsightViewModel();

  AddIcon icon = AddIcon(
    name: "Other Income",
    codePoint: CupertinoIcons.ellipsis.codePoint,
    fontFamily: CupertinoIcons.person_2_fill.fontFamily,
    color: Colors.grey,
  );


  try {
    await viewModel.addIcon(icon);
    print("Icon added successfully!");
  } catch (e) {
    print("Failed to add icon: $e");
  }
}
