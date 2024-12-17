import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:workshop_2/budget_category_page.dart';
import 'package:intl/intl.dart';
import 'package:workshop_2/budget_tab_page.dart';

class EditAIBudget extends StatefulWidget{
  const EditAIBudget({super.key});

  @override
  State<EditAIBudget> createState() => _EditAIBudgetState();
}

class _EditAIBudgetState extends State<EditAIBudget> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget"),
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
                      name: "Name",
                      hint: "Budget Name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BudgetInputField(
                      name: "Amount",
                      hint: "Enter Amount",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BudgetForContainer(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BudgetCategory())
                          );
                        }
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: RecurrenceContainer(
                  //     onTap: () => print("Budget For clicked"),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StartDateContainer(),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        child:CustomButton(
                          text: "Done Edit",
                          onTap: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        child:CustomButton(
                          text: "Delete",
                          onTap: () {
                            _showDeleteConfirmation(context);
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
  final String hint;

  const BudgetInputField({
    super.key,
    required this.name,
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
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
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

  const StartDateContainer({super.key,});

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    DateTime? picked = await showMonthYearPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDate: initialDate, // Set initial date
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
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
            const Expanded(
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
                    "November 12",
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