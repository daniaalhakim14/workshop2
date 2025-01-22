import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar_widget/Model/SignupLoginPage_model.dart';

import '../../../ViewModel/BudgetTextFieldViewModel.dart';
import '../../../ViewModel/BudgetViewModel.dart';
import '../../../ViewModel/CategoryViewModel.dart';
import '../../../ViewModel/DateViewModel.dart';
import 'budget_category_page.dart';


class CreateBudget extends StatefulWidget{
  final UserInfoModule userInfo;
  const CreateBudget({super.key,required this.userInfo});

  @override
  State<CreateBudget> createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {

  late int userid;

  @override
  void initState() {
    super.initState();
    userid = widget.userInfo.id;
    // Fetch budget data when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Budget",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Color(0xFF65ADAD),
      ),
      body: Consumer<BudgetViewModel>(
        builder: (context, budgetViewModel, child) {
          if (budgetViewModel.isLoading) {
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
                      Consumer<BudgetTextFieldViewModel>(
                        builder: (context, viewModel, child) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BudgetInputField(
                                  name: "Name",
                                  hint: "Budget Name",
                                  controller: viewModel.budgetNameController,
                                  onChange: viewModel.updateTextFieldValue,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BudgetInputField(
                                  name: "Amount",
                                  hint: "Enter Amount",
                                  controller: viewModel.budgetAmountController,
                                  onChange: viewModel.updateTextFieldValue,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Consumer<CategoryViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (viewModel.error != null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(viewModel.error!),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => viewModel.fetchCategories(),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: BudgetForContainer(
                                selectedCategoryNames: viewModel.getSelectedCategoryNames(),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BudgetChoosingCategory())
                                  );
                                }
                            ),
                          );
                        },
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: RecurrenceContainer(
                      //     onTap: () => print("Budget For clicked"),
                      //   ),
                      // ),
                      Consumer<DateViewModel>(
                        builder: (context, viewModel, child) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: StartDateContainer(
                              onTap: () {
                                viewModel.selectDate(context);
                              },
                              formattedDate: viewModel.formattedSelectedDate,
                            ),
                          );
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            child:CustomButton(
                              text: "Create Budget",
                              onTap: () async {
                                final textFieldViewModel = context.read<BudgetTextFieldViewModel>();
                                final dateViewModel = context.read<DateViewModel>();
                                final categoryViewModel = context.read<CategoryViewModel>();

                                final name = textFieldViewModel.budgetNameValue;
                                final amount = textFieldViewModel.budgetAmountValue;
                                final startdate = dateViewModel.yearMonthDay;
                                final recurrence = "monthly";


                                await budgetViewModel.createBudget(
                                  name: name,
                                  amount: amount,
                                  startdate: startdate,
                                  recurrence: recurrence,
                                  userid: userid,
                                  categories: categoryViewModel.getSelectedCategory(),
                                );

                                if (budgetViewModel.error == null) {
                                  showAutoDismissAlert(context, "Alert", "Create Budget Successfully");
                                  // Delay navigation to allow the alert to be seen
                                  await Future.delayed(Duration(seconds: 3));
                                  textFieldViewModel.budgetNameController.clear();
                                  textFieldViewModel.budgetAmountController.clear();
                                  Navigator.pop(context);
                                }
                                else {
                                  showAutoDismissAlert(context, "Error", budgetViewModel.error!);
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
      ),
    );
  }
}

class BudgetInputField extends StatelessWidget {
  final String name;
  final String hint;
  final TextEditingController controller;
  final Function onChange;

  const BudgetInputField({
    super.key,
    required this.name,
    required this.hint,
    required this.controller,
    required this.onChange,
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
            onChanged: (value) {
              onChange();
            },
          ),
        ),
      ],
    );
  }
}

// =================== BudgetForContainer ===================
class BudgetForContainer extends StatelessWidget {
  final VoidCallback onTap;
  final List<String> selectedCategoryNames;

  const BudgetForContainer({
    super.key,
    required this.onTap,
    required this.selectedCategoryNames,
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
            const Icon(Icons.calculate_outlined, size: 28, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
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
                    selectedCategoryNames.join(', '),
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
