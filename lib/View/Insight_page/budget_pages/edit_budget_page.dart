import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';


import '../../../Model/Budget.dart';
import '../../../ViewModel/BudgetViewModel.dart';
import '../../../ViewModel/DateViewModel.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';

class EditBudget extends StatefulWidget{
  final BudgetDisplay budget;

  const EditBudget({
    super.key,
    required this.budget,
  });

  @override
  State<EditBudget> createState() => _EditBudgetState();
}

class _EditBudgetState extends State<EditBudget> {
  late TextEditingController budgetNameController;
  late TextEditingController budgetAmountController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial value
    budgetNameController = TextEditingController(text: widget.budget.budgetName);
    budgetAmountController = TextEditingController(text: widget.budget.totalAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);
    return Scaffold(
      backgroundColor: backgroundColor,



      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black, // Back arrow color
        ),
        title: const Text(
            "Budget",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              //bottom: MediaQuery.of(context).viewInsets.bottom + 80.0, // Add extra padding
            ),
            child: SingleChildScrollView(
              child: Consumer<BudgetViewModel>(
                  builder: (context, budgetViewModel, child) {
                    if (budgetViewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BudgetInputField(
                            name: "Budget Name",
                            hint: "Budget Name",
                            controller: budgetNameController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BudgetInputField(
                            name: "Budget Amount",
                            hint: "Enter Amount",
                            controller: budgetAmountController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Budget for ${widget.budget.categorynames}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: isDarkMode ? Colors.white : Colors.black, // Adjust color dynamically
                            ),
                          ),                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: RecurrenceContainer(
                        //     onTap: () => print("Budget For clicked"),
                        //   ),
                        // ),
                        Consumer<DateViewModel>(
                          builder: (datecontext, dateViewModel, child) {

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: StartDateContainer(
                                onTap: () {
                                  dateViewModel.selectDate(datecontext);
                                },
                                formattedDate: dateViewModel.formattedSelectedDate,
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              child:CustomButton(
                                text: "Done Edit",
                                onTap: () async {
                                  // Show loading indicator
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(child: CircularProgressIndicator()),
                                  );

                                  final dateViewModel = context.read<DateViewModel>();

                                  try {
                                    await budgetViewModel.updateBudget(
                                      widget.budget.budgetId,
                                      budgetNameController.text,
                                      double.parse(budgetAmountController.text),
                                      dateViewModel.yearMonthDay, // Use the selected date
                                    );

                                    if (budgetViewModel.error == null) {
                                      Navigator.pop(context); // Close the loading dialog
                                      showAutoDismissAlert(context, "Alert", "Budget Updated Successfully");

                                      // Fetch budgets after update
                                      // await budgetViewModel.fetchBudgets(1);

                                      await Future.delayed(Duration(seconds: 3));

                                      // Pop the screen only after the budget update is finished
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      Navigator.pop(context); // Close the loading dialog
                                      showAutoDismissAlert(context, "Error", budgetViewModel.error!);
                                    }
                                  } catch (e) {
                                    Navigator.pop(context); // Close the loading dialog
                                    showAutoDismissAlert(context, "Error", "An unexpected error occurred: $e");
                                  }
                                },
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
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
  final String hint;
  final TextEditingController controller;

  const BudgetInputField({
    super.key,
    required this.name,
    required this.hint,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text
        Padding(
          padding: EdgeInsets.only(bottom: 8.0), // Adds spacing below the label
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black, // White for dark mode, black for default
            ),
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
            controller: controller,
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

// =================== BudgetForContainer ===================
class BudgetForContainer extends StatelessWidget {
  final VoidCallback onTap;

  const BudgetForContainer({
    super.key,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.calculate_outlined, size: 28, color: Colors.black),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget For",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "All Expenses",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// // =================== RecurrenceContainer ===================
// class RecurrenceContainer extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const RecurrenceContainer({
//     super.key,
//     required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Icon(Icons.calendar_today_outlined, size: 28, color: Colors.black),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Recurrence",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "Recurrence type",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.expand_more, color: Colors.black),
//           ],
//         ),
//       ),
//     );
//   }
// }

// =================== StartDateContainer ===================
class StartDateContainer extends StatelessWidget {

  final VoidCallback onTap;
  final String formattedDate;

  const StartDateContainer({
    super.key,
    required this.onTap,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline, size: 28, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Start Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: Colors.black),
          ],
        ),
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