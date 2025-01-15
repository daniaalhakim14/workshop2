import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_2/View/ai_budget.dart';
import 'package:workshop_2/ViewModel/AIBudgetTextFieldViewModel.dart';
import 'package:workshop_2/ViewModel/AIBudgetViewModel.dart';

class CreateAIBudget extends StatefulWidget{
  const CreateAIBudget({super.key});

  @override
  State<CreateAIBudget> createState() => _CreateAIBudgetState();
}

class _CreateAIBudgetState extends State<CreateAIBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
            'Create AI-Generated Budget',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Color(0xFF65ADAD),
      ),
      body: Consumer<AIBudgetViewModel>(
        builder: (context, viewModel, child) {
          return Consumer<AIBudgetTextFieldViewModel>(
            builder: (context, textViewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      //bottom: MediaQuery.of(context).viewInsets.bottom + 80.0, // Add extra padding
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BudgetInputField(
                              name: "Monthly Income",
                              extra: "",
                              hint: "Enter Monthly Income",
                              controller: textViewModel.monthlyIncomeController,
                              // onChange: textViewModel.updateTextFieldValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BudgetInputField(
                              name: "Essential Expenses",
                              extra: "(Rents, Utilities, Groceries...)",
                              hint: "Budget Amount",
                              controller: textViewModel.essentialExpensesController,
                              // onChange: textViewModel.updateTextFieldValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BudgetInputField(
                              name: "Variable Expenses",
                              extra: "(Entertainment, Shopping...)",
                              hint: "Enter Amount",
                              controller: textViewModel.variableExpensesController,
                              // onChange: textViewModel.updateTextFieldValue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BudgetInputField(
                              name: "Saving Goals In 10 Years",
                              extra: "",
                              hint: "Enter Amount",
                              controller: textViewModel.savingGoalsController,
                              // onChange: textViewModel.updateTextFieldValue,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                child: CustomButton(
                                  text: "Generate Budget Plan",
                                  onTap: () async {
                                    await viewModel.generateAIBudget(
                                        textViewModel.monthlyIncomeController.text,
                                        textViewModel.essentialExpensesController.text,
                                        textViewModel.variableExpensesController.text,
                                        textViewModel.savingGoalsController.text,
                                    );

                                    if (viewModel.error == null) {
                                      // Navigate to the BudgetListPage after generating budgets
                                      textViewModel.monthlyIncomeController.clear();
                                      textViewModel.essentialExpensesController.clear();
                                      textViewModel.variableExpensesController.clear();
                                      textViewModel.savingGoalsController.clear();
                                      Navigator.pop(context, 'success');
                                    }
                                    else {
                                      showAutoDismissAlert(context, "Error", viewModel.error!);
                                    }
                                  },
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ],
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

class BudgetInputField extends StatelessWidget {
  final String name;
  final String extra;
  final String hint;
  final TextEditingController controller;
  // final Function onChange;

  const BudgetInputField({
    super.key,
    required this.name,
    required this.extra,
    required this.hint,
    required this.controller,
    // required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text
        Padding(
          padding: EdgeInsets.only(bottom: 8.0), // Adds spacing below the label
          child: Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                extra,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        // Text input field
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Subtle shadow
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint, // Placeholder text
              hintStyle: TextStyle(
                color: Colors.grey.shade400, // Hint text color
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ),
              border: InputBorder.none, // Remove default border
            ),
            controller: controller,
            // onChanged: onChange(),
          ),
        ),
      ],
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

void showAutoDismissAlert(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Schedule a delayed dismissal of the alert dialog after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop(); // Close the dialog
      });

      // Return the AlertDialog widget
      return AlertDialog(
        title: Text(title),
        content: Text(content),
      );
    },
  );
}