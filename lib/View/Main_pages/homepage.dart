import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar_widget/Model/Income_model.dart';
import '../../Model/InsightPage_model.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../../ViewModel/Income/Income_View_Model.dart';
import '../../ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import '../../ViewModel/account_viewmodel.dart';
import '../../ViewModel/app_appearance_viewmodel.dart';
import 'account_page.dart';
import 'insight_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  final UserInfoModule userInfo;

  const HomePage({super.key, required this.userInfo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVisible = true; // Tracks whether the balance is visible
  String selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());  // Declare variable selectedMonth to store selectedMonth
  String _formatMonth(DateTime date) {
    return "${_monthNameTransactionList(date.month)} ${date.year}";
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
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final viewModel = Provider.of<InsightViewModel>(context, listen: false);
      viewModel.fetchTransactionList(widget.userInfo.id);
      viewModel.fetchTransactionsExpense(widget.userInfo.id);
      final incomeViewModel = Provider.of<IncomeViewModel>(context, listen: false);
      incomeViewModel.fetchIncomeAmount(widget.userInfo.id); // Pass the user ID
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAppearanceViewModel>(
      builder: (context, appAppearanceViewModel, child) {
        final isDarkMode = appAppearanceViewModel.isDarkMode;
        final backgroundColor = isDarkMode ? Colors.black : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFF65ADAD),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 69,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 40, left: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<AccountViewModel>(
                    builder: (context, accountViewModel, child) {
                      final avatarBytes = accountViewModel.avatarBytes;
                      final isLoading = accountViewModel.isLoading;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            key: ValueKey(avatarBytes != null
                                ? DateTime.now().millisecondsSinceEpoch
                                : 'default_avatar'),
                            radius: 20,
                            backgroundColor:
                            isDarkMode ? Colors.grey[800] : Colors.white,
                            backgroundImage: avatarBytes != null
                                ? MemoryImage(avatarBytes)
                                : null,
                            child: avatarBytes == null && !isLoading
                                ? const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 40,
                            )
                                : null,
                          ),
                          if (isLoading)
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkMode ? Colors.white : Colors.black,
                              ),
                              strokeWidth: 2,
                            ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello, ${widget.userInfo.name}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              height: 0.8
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFF65ADAD)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 30,left: 30,right: 30),
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7C1E6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Balance',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Consumer<IncomeViewModel>(
                                    builder: (context, incomeViewModel, child) {
                                      if (incomeViewModel.fetchingData) {
                                        return const CircularProgressIndicator(); // Show a loader while data is being fetched
                                      }
                                      double totalIncome = 0.0;
                                      for (var income in incomeViewModel.incomeAmount) {
                                        if (income.incomeAmount != null) {
                                          totalIncome += income.incomeAmount!;
                                        }
                                      }
                                      return Consumer<InsightViewModel>(
                                        builder: (context, viewModel, child) {
                                          double totalExpense = 0.0;

                                          for (var expense in viewModel.transactionsExpense) {
                                            if (expense.amount != null) {
                                              totalExpense += expense.amount!;
                                            }
                                          }

                                          double balance = totalIncome - totalExpense;
                                          print('total expense: $totalExpense');
                                          return Row(
                                            children: [
                                              // Conditional rendering of the balance text
                                              isVisible
                                                  ? Text(
                                                'RM ${balance.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                                  : const Text(
                                                'RM ****', // Placeholder when hidden
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isVisible = !isVisible; // Toggle visibility
                                                  });},
                                                icon: Icon(
                                                  isVisible ? Icons.visibility : Icons.visibility_off,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 430,
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Spending Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (homeContext) => Insight(userInfo: widget.userInfo), // Pass UserModel
                                ),
                              );
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Consumer<InsightViewModel>(
                  builder: (context, viewModel, child) {
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
                      String formattedDate = DateFormat('MMMM yyyy').format(dateTime);
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

                    return  Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0,bottom: 10.0),
                      child: Container(
                        height: 384, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Latest Transaction: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Divider(color: Colors.grey[400], thickness: 1),
                                ],
                              ),
                            ),
                            // Transactions List
                            Column(
                              children: filteredTransactions.take(3).map((transaction) {
                                String isoFormatDate = transaction.date.toString();
                                DateTime dateTime = DateTime.parse(isoFormatDate);
                                String formattedDate = _formatFullDate(dateTime);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Leading Icon and Transaction Details
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor: transaction.iconColor,
                                                child: Icon(
                                                  transaction.iconData,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Transaction Details
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transaction.name.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    transaction.description.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            transaction.transactiontype == 'Expense'
                                                ? '- RM ${transaction.amount?.toStringAsFixed(2)}'
                                                : '+ RM ${transaction.amount?.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: transaction.transactiontype == 'Expense' ? Colors.red : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),

                    );

                  },
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: isDarkMode ? Colors.black : const Color(0xFF002B36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.home_outlined,
                    color: isDarkMode
                        ? Colors.teal
                        : const Color(0xFF65ADAD), // Highlight active tab
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Insight(userInfo: widget.userInfo),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'lib/Icons/three lines.png',
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
                        builder: (context) =>
                            Noti(userInfo: widget.userInfo),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => AccountViewModel(),
                          child: Account(userInfo: widget.userInfo),
                        ),
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
            ),
          ),
        );
      },
    );
  }
}

class SpendingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final String category;
  final Color? backgroundColor;

  const SpendingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.category,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns items at the start vertically
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: backgroundColor ?? Colors.grey[200],
                radius: 24,
                child: Icon(icon, color: Colors.teal),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: category == 'Food & Drinks' || category == 'Groceries' || category == 'Home' ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black, // Set the date text color to black
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications Page'),
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text('Account'),
      ),
      body: const Center(
        child: Text('Account Page'),
      ),
    );
  }
}