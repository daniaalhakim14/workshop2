import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workshop_2/create_budget_page.dart';
import 'package:workshop_2/edit_budget_page.dart';

class BudgetDetail extends StatefulWidget{
  const BudgetDetail({super.key});

  @override
  State<BudgetDetail> createState() => _BudgetDetailState();
}

class _BudgetDetailState extends State<BudgetDetail> {
  final double progressPercentage = 30.0;

  @override
  Widget build(BuildContext context) {
    void _showDeleteConfirmation(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure you want to delete Budget?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform delete operation
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Name'),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to the edit page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditBudget()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {_showDeleteConfirmation(context)},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RM XXXX',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Be careful! You shouldn\'t spend more than RMXXXX each day for the rest of the period.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
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
            Text(
              "November 2024",
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to budget overview page
                },
                child: Text('Budget Overview'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}