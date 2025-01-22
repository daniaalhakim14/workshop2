import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/Budget.dart';
import '../../../Model/SignupLoginPage_model.dart';
import '../../../ViewModel/BudgetViewModel.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';
import 'ai_budget.dart';
import 'budget_detail_page.dart';
import 'create_ai_budget_page.dart';
import 'create_budget_page.dart';


class budget extends StatefulWidget{
  final UserInfoModule userInfo;
  const budget({super.key,required this.userInfo});

  @override
  State<budget> createState() => _budgetState();
}

class _budgetState extends State<budget> {
  late int userid;
  late UserInfoModule userInfo;

  @override
  void initState() {
    super.initState();
    userid = widget.userInfo.id;
    userInfo = widget.userInfo;
    // Fetch budget data when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetViewModel>(context, listen: false).fetchBudgets(userid);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch budget data whenever dependencies change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetViewModel>(context, listen: false).fetchBudgets(userid);
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Fetch budget data when the screen is opened or dependencies change
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<BudgetViewModel>(context, listen: false).fetchBudgets(userid);
  //   });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: Stack(
        children: [
          // Main Content: Scrollable Budget Card List
          SingleChildScrollView(
            child: Consumer<BudgetViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.budgets == []) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(viewModel.error!),
                      ],
                    ),
                  );
                }

                if (viewModel.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(viewModel.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.fetchBudgets(userid),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: screenHeight, // Limit maximum height
                          ),
                          child: BudgetCardList(
                            budgetData: viewModel.budgetdisplay,
                            userid: userid,
                            parentContext: context,
                            userInfo: userInfo,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Add space below the list
                  ],
                );
              },
            ),
          ),

          // Floating Buttons (Bottom-right corner)
          // Floating Buttons aligned to bottom-center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize Column height
                children: [
                  Consumer<BudgetViewModel>(
                    builder: (context, viewModel, child) {
                      return Column(
                        children: [
                          CustomButton(
                            text: "Create a New Budget",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateBudget(userInfo: widget.userInfo), // Replace with your edit page
                                ),
                              ).then((value) {
                                // Refresh data after navigating back
                                viewModel.fetchBudgets(userid);
                              });
                            },
                            backgroundColor: Colors.blueAccent,
                          ),
                          const SizedBox(height: 12), // Add space between buttons
                          CustomButton(
                            text: "AI Created Budget Plan",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateAIBudget())
                              ).then((result) {
                                if (result == "success") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AIBudget(userInfo: widget.userInfo))
                                  ).then((result) async {
                                    viewModel.fetchBudgets(userid);
                                    showAutoDismissAlert(context, "Alert", result);
                                    // Allow user to see the alert, then navigate back
                                    await Future.delayed(Duration(seconds: 3));
                                  });
                                }
                              });
                            },
                            backgroundColor: Colors.greenAccent,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String budgetName;
  final double amountLeft;
  final double totalAmount;
  final double progressPercentage;
  final String categorynames;
  final String date;
  final VoidCallback onTap;

  const BudgetCard({
    super.key,
    required this.budgetName,
    required this.amountLeft,
    required this.totalAmount,
    required this.progressPercentage,
    required this.date,
    required this.onTap,
    required this.categorynames,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    if (progressPercentage <= 25) {
      // Interpolate between blue and yellow
      color = Color.lerp(Colors.blue, Colors.yellow, progressPercentage / 25)!;
    } else if (progressPercentage <= 50) {
      // Interpolate between yellow and orange
      color = Color.lerp(Colors.yellow, Colors.orange, (progressPercentage - 25) / 25)!;
    } else if (progressPercentage <= 75) {
      // Interpolate between orange and red
      color = Color.lerp(Colors.orange, Colors.red, (progressPercentage - 50) / 25)!;
    } else {
      // Interpolate between red and red (fully red)
      color = Colors.red;
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.blue, width: 1.5),
        ),
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Name
              Text(
                budgetName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),

              // Amount Left and Total Amount
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'RM ${amountLeft.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' left out of ',
                    ),
                    TextSpan(
                      text: 'RM ${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),

              // Progress Bar
              Stack(
                children: [
                  Container(
                    height: 25.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progressPercentage / 100,
                    child: Container(
                      height: 25.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: color,
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Text(
                  //     '${progressPercentage.toStringAsFixed(1)}%',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 12.0,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                '${progressPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Budget for $categorynames',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),

              // Footer (Date Label)
              Text(
                date,
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetCardList extends StatelessWidget {
  final List<BudgetDisplay> budgetData;
  final int userid;
  final BuildContext parentContext;
  final UserInfoModule userInfo;

  const BudgetCardList({
    super.key,
    required this.budgetData,
    required this.userid,
    required this.parentContext,
    required this.userInfo
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 500.0), // Add bottom padding
      itemCount: budgetData.length,
      itemBuilder: (context, index) {
        final budget = budgetData[index];
        return BudgetCard(
          budgetName: budget.budgetName,
          amountLeft: budget.amountLeft,
          totalAmount: budget.totalAmount,
          progressPercentage: budget.progressPercentage,
          categorynames: budget.categorynames,
          date: budget.date,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BudgetDetail(
                budget: budget,
                userInfo: userInfo,
              )),
            ).then((result) async {
              if (result == "Delete budget successfully") {
                showAutoDismissAlert(parentContext, "Alert", result);
                // Allow user to see the alert, then navigate back
                await Future.delayed(Duration(seconds: 3));
              }
            });
          },
        );
      },
    );
  }
}

Future<void> showAutoDismissAlert(BuildContext context, String title, String content) async {
  final navigatorContext = Navigator.of(context).context; // Get a valid parent context
  await showDialog(
    context: navigatorContext,
    builder: (BuildContext dialogContext) {
      return FutureBuilder<void>(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Navigator.of(dialogContext).pop();
          }
          return AlertDialog(
            title: Text(title),
            content: Text(content),
          );
        },
      );
    },
  );
}