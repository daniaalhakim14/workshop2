import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tab_bar_widget/Model/SignupLoginPage_model.dart';


import '../../../Model/Budget.dart';
import '../../../ViewModel/AIBudgetViewModel.dart';
import '../../../ViewModel/BudgetViewModel.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';

class AIBudget extends StatefulWidget{
  final UserInfoModule userInfo;
  const AIBudget({super.key,required this.userInfo});

  @override
  State<AIBudget> createState() => _AIBudgetState();
}

class _AIBudgetState extends State<AIBudget> {

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);
    final double screenHeight = MediaQuery.of(context).size.height;

    int userid = widget.userInfo.id;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black, // Back arrow color
        ),
        title: const Text(
            'AI-Generated Budget Plan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
      body: Consumer<BudgetViewModel>(
        builder: (budgetContext, budgetViewModel, child) {
          if (budgetViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<AIBudgetViewModel>(
            builder: (context, viewModel, child) {
              return Stack(
                children: [
                  // Main Content: Scrollable Budget Card List
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight, // Limit maximum height
                              ),
                              child: AIBudgetCardList(
                                aibudgets: viewModel.aibudgets,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100), // Add space below the list
                      ],
                    ),
                  ),

                  // Floating Buttons (Bottom-right corner)
                  // Floating Buttons aligned to bottom-center
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: CustomButton(
                        text: "Save",
                        onTap: () async {
                          await budgetViewModel.postBudgets(viewModel.aibudgets, userid);

                          // Handle success or error based on _error state
                          if (budgetViewModel.error == null) {
                            Navigator.pop(budgetContext, "Create budgets successfully");
                          }
                          else {
                            Navigator.pop(budgetContext, budgetViewModel.error);
                          }
                        },
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String budgetName;
  final String budgetAmount;
  final String startDate;

  const BudgetCard({
    super.key,
    required this.budgetName,
    required this.budgetAmount,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => EditBudget())
        // );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budgetName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          budgetAmount,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Start Date: $startDate',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //const Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

class AIBudgetCardList extends StatelessWidget {
  final List<AIGeneratedBudget> aibudgets;

  const AIBudgetCardList({
    super.key,
    required this.aibudgets,
  });

  // final List<Map<String, dynamic>> budgetData = [
  //   {
  //     'budgetName': 'November Grocery',
  //     'budgetAmount': 1000,
  //     'startDate': 'November 2024',
  //   },
  //   {
  //     'budgetName': 'November Food',
  //     'budgetAmount': 1500,
  //     'startDate': 'November 2024',
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 500.0), // Add bottom padding
      itemCount: aibudgets.length,
      itemBuilder: (context, index) {
        final aibudget = aibudgets[index];
        return BudgetCard(
          budgetName: aibudget.budgetname,
          budgetAmount: aibudget.amount.toString(),
          startDate: DateFormat('MMMM yyyy').format(DateTime.now()),
        );
      },
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