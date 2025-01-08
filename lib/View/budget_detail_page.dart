import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_2/View/edit_budget_page.dart';
import 'package:workshop_2/ViewModel/BudgetViewModel.dart';

import '../Model/Budget.dart';

class BudgetDetail extends StatefulWidget{
  final BudgetDisplay budget;

  const BudgetDetail({
    super.key,
    required this.budget,
  });

  @override
  State<BudgetDetail> createState() => _BudgetDetailState();
}

class _BudgetDetailState extends State<BudgetDetail> {

  late BudgetDisplay _currentBudget;

  @override
  void initState() {
    super.initState();
    _currentBudget = widget.budget; // Initialize the mutable budget
  }

  @override
  Widget build(BuildContext context) {
     void _showDeleteConfirmation(BuildContext context, BudgetViewModel budgetViewModel) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure you want to delete Budget?'),
          actions: [
            TextButton(
              onPressed: () {
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
        title: Text(
            _currentBudget.budgetName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Color(0xFF65ADAD),
        actions: [
          GestureDetector(
            onTap: () async {
              // Navigate to the edit page and wait for the result

              // Navigator.pop(context);
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => EditBudget(budget: _currentBudget)),
              // );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Consumer<BudgetViewModel>(
            builder: (context, budgetViewModel, child) {
              return GestureDetector(
                onTap: () async {
                  _showDeleteConfirmation(context, budgetViewModel);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RM ${_currentBudget.totalAmount}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Be careful! You shouldn\'t spend more than RM${_currentBudget.amountLeft} each day for the rest of the period.',
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
                  widthFactor: _currentBudget.progressPercentage / 100,
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
                    '${_currentBudget.progressPercentage}%',
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
              'Budget for ${_currentBudget.categorynames}',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 8.0),
            Text(
              _currentBudget.date,
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 16.0),
            // Align(
            //   alignment: Alignment.center,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Navigate to budget overview page
            //     },
            //     child: Text('Budget Overview'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}