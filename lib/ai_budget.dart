import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workshop_2/edit_ai_budget_page.dart';

class AIBudget extends StatefulWidget{
  const AIBudget({super.key});

  @override
  State<AIBudget> createState() => _AIBudgetState();
}

class _AIBudgetState extends State<AIBudget> {

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Personalized Budget"),
      ),
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
                      child: AIBudgetCardList(),
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
                onTap: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ),
        ],
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
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditAIBudget()),
        )
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    budgetName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Grocery Monthly',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
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
              const Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

class AIBudgetCardList extends StatelessWidget {
  final List<Map<String, dynamic>> budgetData = [
    {
      'budgetName': 'November Grocery',
      'budgetAmount': 1000,
      'startDate': 'November 2024',
    },
    {
      'budgetName': 'November Food',
      'budgetAmount': 1500,
      'startDate': 'November 2024',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 500.0), // Add bottom padding
      itemCount: budgetData.length,
      itemBuilder: (context, index) {
        final budget = budgetData[index];
        return BudgetCard(
          budgetName: budget['budgetName'],
          budgetAmount: budget['budgetAmount'].toString(),
          startDate: budget['startDate'].toString(),
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