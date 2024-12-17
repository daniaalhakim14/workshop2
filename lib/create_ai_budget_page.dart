import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workshop_2/ai_budget.dart';

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
        title: const Text("Create Personalized Budget"),
      ),
      body: Stack(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BudgetInputField(
                      name: "Essential Expenses",
                      extra: "(Rents, Utilities, Groceries...)",
                      hint: "Budget Amount",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BudgetInputField(
                      name: "Variable Expenses",
                      extra: "(Entertainment, Shopping...)",
                      hint: "Enter Amount",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BudgetInputField(
                      name: "Financial Goals",
                      extra: "",
                      hint: "Enter Amount",
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: CustomButton(
                          text: "Generate Budget Plan",
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => AIBudget())
                            );
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
      ),
    );
  }
}

class BudgetInputField extends StatelessWidget {
  final String name;
  final String extra;
  final String hint;

  const BudgetInputField({
    super.key,
    required this.name,
    required this.extra,
    required this.hint,
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