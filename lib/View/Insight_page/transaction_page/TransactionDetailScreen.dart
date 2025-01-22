import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/InsightPage_model.dart';
import '../../../ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';
import 'edit_transaction.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key, required this.userid,required this.listDetail});
  final int userid;
  final TransactionList listDetail;

  @override
  _TransactionDetailScreenState createState() => _TransactionDetailScreenState();
}
class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionList transactionDetail;

  @override
  void initState() {
    super.initState();
    transactionDetail = widget.listDetail; // Initialize with the provided details
  }

  Future<void> refreshTransactionDetails() async {
    final viewModel = Provider.of<InsightViewModel>(context, listen: false);
    await viewModel.fetchTransactionsExpense(widget.userid); // Refresh transactions from view model
    await viewModel.fetchTransactionList(widget.userid);

    // Find the updated transaction in the list
    final updatedTransaction = viewModel.transactionList.firstWhere(
          (transaction) => transaction.transactionId == transactionDetail.transactionId,
      orElse: () => transactionDetail,
    );

    setState(() {
      transactionDetail = updatedTransaction;
    });
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'No date available'; // Fallback message for null date
    }

                                    //DateTime localDateTime = dateTime.toLocal(); // Convert to local time
                                        
    return DateFormat('h:mma, dd MMM yyyy').format(dateTime).toLowerCase();
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
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF65ADAD),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black, // Back arrow color
        ),
        title: Text(
          transactionDetail.name.toString(),
          style: TextStyle(fontWeight: FontWeight.bold,                 color: isDarkMode ? Colors.white :  Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Center(
                child: Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: transactionDetail.iconColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      transactionDetail.iconData,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '${transactionDetail.name}',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white :  Colors.black,

              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              formatDateTime(transactionDetail.date),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white :  Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    transactionDetail.transactiontype == 'Expense' ? '-RM ' : '+RM ',
                    style: TextStyle(
                      color: transactionDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  transactionDetail.amount?.toStringAsFixed(2) ?? '0.00',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: transactionDetail.transactiontype == 'Expense' ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Text(
              'Description: ${transactionDetail.description}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: isDarkMode ? Colors.white :  Colors.black,

              ),
            ),
            Text(
              'Payment Type: ${transactionDetail.paymenttype}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: isDarkMode ? Colors.white :  Colors.black,

              ),
            ),
            const SizedBox(height: 100.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit Button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => edit_transaction(
                              userid: widget.userid,
                              transactionDetail: transactionDetail,
                            ),
                          ),
                        );
                        // If transaction is edited, refresh
                        if (result == true) {
                          print("Refreshing transaction details...");
                          await refreshTransactionDetails();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color of the button
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust button size
                      ),
                      child: const Icon(
                        Icons.edit_note_outlined,
                        size: 27, // Icon size
                        color: Colors.blue, // Icon color
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between button and text
                    const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Matches the button theme
                      ),
                    ),
                  ],
                ),
                // Delete Button
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add delete functionality if needed
                        showDeleteConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color of the button
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust button size
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 27, // Icon size
                        color: Colors.red, // Icon color
                      ),
                    ),
                    const SizedBox(height: 8.0), // Space between button and text
                    const Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // Matches the button theme
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'delete transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      onPressed: () async {
                        if(transactionDetail.transactiontype == "Expense"){
                          final viewModel = Provider.of<InsightViewModel>(context, listen: false);
                          await viewModel.deleteExpense(transactionDetail.transactionId!,widget.userid);
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(true); // Go back with result
                        }else{
                          final viewModel = Provider.of<InsightViewModel>(context, listen: false);
                          await viewModel.deleteIncome(transactionDetail.transactionId!,widget.userid);
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(true); // Go back with result
                        }

                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}