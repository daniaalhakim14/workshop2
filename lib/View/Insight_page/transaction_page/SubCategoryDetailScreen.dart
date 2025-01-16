import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Model/insight_model.dart';
import 'TransactionDetailScreen.dart';


class SubCategoryDetailScreen extends StatefulWidget {
  final String subcategoryName;
  final List<TransactionList> transactions;

  const SubCategoryDetailScreen({
    super.key,
    required this.subcategoryName,
    required this.transactions,
  });

  @override
  _SubCategoryDetailScreenState createState() => _SubCategoryDetailScreenState();
}
class _SubCategoryDetailScreenState extends State<SubCategoryDetailScreen> {
  late Map<String, List<TransactionList>> groupedByDate;

  @override
  void initState() {
    super.initState();
    groupedByDate = _groupTransactionsByDate(widget.transactions);
  }

  Map<String, List<TransactionList>> _groupTransactionsByDate(List<TransactionList> transactions) {
    final Map<String, List<TransactionList>> grouped = {};
    for (var transaction in transactions) {
      final formattedDate = _formatDate(transaction.date);
      grouped.putIfAbsent(formattedDate, () => []);
      grouped[formattedDate]!.add(transaction);
    }
    return grouped;
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'No date';
    return DateFormat('d MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subcategoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: groupedByDate.keys.length,
        itemBuilder: (context, index) {
          final date = groupedByDate.keys.toList()[index];
          final dateTransactions = groupedByDate[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                height: 30.0,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    date,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              ...dateTransactions.map((transaction) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction.iconColor,
                        child: Icon(
                          transaction.iconData,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        transaction.description ?? 'No Description',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        widget.subcategoryName,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: Text(
                        '-RM ${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailScreen(
                              listDetail: transaction,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}