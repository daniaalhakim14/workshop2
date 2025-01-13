
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar_widget/ViewModel/insight_view_model.dart';
import '../Model/insight_model.dart';
import 'account_page.dart';
import 'add_transaction.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'dart:async';


// configure daily spent and spent so far

class Insight extends StatefulWidget {
  const Insight({super.key});

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
        viewModel.fetchTransactionsExpense();
      }
      viewModel.fetchTransactionList();
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
    return "${_monthNamePieChart(date.month)} ${date.year}";
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
    return "${date.day.toString().padLeft(2, '0')} ${_monthNameTransactionList(date.month)} ${date.year}";
  }


  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Insight',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
                  const Center(child: Text('Budget Data')),
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

                                if (expense.categoryname != null && formattedExpenseDate == selectedMonth) {
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
                          const SizedBox(height: 20),
                          // To display transaction list
                          Consumer<InsightViewModel>(
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
                              /*

                              return Column(
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: transactionList.length,
                                      itemBuilder: (context, index){
                                            return TransactionCard(list: transactionList[index]);
                                      },
                                    ),
                                  ),
                                ],
                              );
                              */
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.4,
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
                                                border: const Border(
                                                  top: BorderSide(
                                                    color: Colors.grey, // Adjust color to your preference
                                                    width: 1.0,         // Thickness of the border
                                                  ),
                                                ),
                                              ),
                                              height: 30.0,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                                child: Text(
                                                  formattedDate, // Display the transaction date
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),

                                          // Transaction Details
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: transaction.iconColor,
                                              child: Icon(
                                                transaction.iconData,
                                                color: Colors.white,
                                              ),
                                            ),
                                            title: Text(
                                              transaction.name.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
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
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );

                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Center(child: Text('Analysis Data')),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const add_transaction(),
              ),
            );
            // If a new transaction was added, refresh the list
            if (result == true) {
              print("Refreshing transaction list...");
              final viewModel = Provider.of<InsightViewModel>(context, listen: false);
              viewModel.fetchTransactionsExpense(); // Fetch the latest transactions
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Transaction'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF002B36),
          child: _bottomBarConfiguration(context),
        ),
      ),
    );
  }
}


class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this. listDetail});
  final TransactionList listDetail;

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'No date available'; // Fallback message for null date
    }
    return DateFormat('h:mma, dd MMM yyyy').format(dateTime).toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listDetail.name.toString(),
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
              child: Center(
                child: Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: listDetail.iconColor,
                    shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 3,
                      )
                  ),
                  child: Center(
                    child: Icon(
                      listDetail.iconData,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
                ),
              ),
            ),
            Text('${listDetail.name}',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text('${formatDateTime(listDetail.date)}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    listDetail.transactiontype == 'Expense' ? '-RM ' : '+RM ',
                    style: TextStyle(
                      color: listDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  listDetail.amount?.toStringAsFixed(2) ?? '0.00',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: listDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Text('Description: ${listDetail.description}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,),
            ),
            Text('Payment Type: ${listDetail.paymenttype}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,),
            ),
            const SizedBox(height: 100.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit Button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color of the button
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust button size
                      ),
                      child: const Icon(
                        Icons.edit_note_outlined,
                        size: 27, // Icon size
                        color: Colors.blue, // Icon color
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between button and text
                    const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Matches the button theme
                      ),
                    ),
                  ],
                ),
                // Delete Button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color of the button
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust button size
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 27, // Icon size
                        color: Colors.red, // Icon color
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between button and text
                    const Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // Matches the button theme
                      ),
                    ),
                  ],
                ),
              ],
            )




          ],
        ),
      ),
    );
  }
}



Row _bottomBarConfiguration(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Noti()),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Account()),
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
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          margin: margin,
          width: width,
          height: height,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


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
