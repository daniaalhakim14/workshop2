import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workshop_2/budget_detail_page.dart';
import 'package:workshop_2/create_ai_budget_page.dart';
import 'package:workshop_2/create_budget_page.dart';

class Budget extends StatefulWidget{
  const Budget({super.key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
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
                      child: BudgetCardList(),
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
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize Column height
                children: [
                  CustomButton(
                    text: "Create a New Budget",
                    destinationPage: CreateBudget(),
                    backgroundColor: Colors.blueAccent,
                  ),
                  const SizedBox(height: 12), // Add space between buttons
                  CustomButton(
                    text: "AI Created Budget Plan",
                    destinationPage: CreateAIBudget(),
                    backgroundColor: Colors.greenAccent,
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
  final Widget destinationPage;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.destinationPage,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage)
        );
      },
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
  final String amountLeft;
  final String totalAmount;
  final double progressPercentage;
  final String date;

  const BudgetCard({
    super.key,
    required this.budgetName,
    required this.amountLeft,
    required this.totalAmount,
    required this.progressPercentage,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BudgetDetail()),
        )
      },
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
                      text: 'RM $amountLeft',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' left out of ',
                    ),
                    TextSpan(
                      text: 'RM $totalAmount',
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
                    height: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progressPercentage / 100,
                    child: Container(
                      height: 20.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${progressPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),

              // Footer (Date Label)
              Text(
                date,
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetCardList extends StatelessWidget {
  final List<Map<String, dynamic>> budgetData = [
    {
      'budgetName': 'Groceries',
      'amountLeft': 200,
      'totalAmount': 500,
      'progressPercentage': 60.0,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Utilities',
      'amountLeft': 50,
      'totalAmount': 150,
      'progressPercentage': 66.7,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Entertainment',
      'amountLeft': 100,
      'totalAmount': 300,
      'progressPercentage': 66.7,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Transportation',
      'amountLeft': 80,
      'totalAmount': 200,
      'progressPercentage': 60.0,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Groceries',
      'amountLeft': 200,
      'totalAmount': 500,
      'progressPercentage': 60.0,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Utilities',
      'amountLeft': 50,
      'totalAmount': 150,
      'progressPercentage': 66.7,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Entertainment',
      'amountLeft': 100,
      'totalAmount': 300,
      'progressPercentage': 66.7,
      'date': 'November 2024',
    },
    {
      'budgetName': 'Transportation',
      'amountLeft': 80,
      'totalAmount': 200,
      'progressPercentage': 60.0,
      'date': 'November 2024',
    },
  ];

  BudgetCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 500.0), // Add bottom padding
      itemCount: budgetData.length,
      itemBuilder: (context, index) {
        final budget = budgetData[index];
        return BudgetCard(
          budgetName: budget['budgetName'],
          amountLeft: budget['amountLeft'].toString(),
          totalAmount: budget['totalAmount'].toString(),
          progressPercentage: budget['progressPercentage'],
          date: budget['date'],
        );
      },
    );
  }
}