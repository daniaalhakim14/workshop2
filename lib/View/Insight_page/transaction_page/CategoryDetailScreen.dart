import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Model/InsightPage_model.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';
import 'SubCategoryDetailScreen.dart';


class CategoryDetailScreen extends StatefulWidget {
  final userid;
  final String categoryName;
  final List<TransactionList> categoryTransactions;

  const CategoryDetailScreen({
    super.key,
    required this.userid,
    required this.categoryName,
    required this.categoryTransactions,
  });

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}
class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late Map<String, List<TransactionList>> groupedSubcategories;

  @override
  void initState() {
    super.initState();
    groupedSubcategories = _groupTransactionsBySubcategory(widget.categoryTransactions);
  }

  Map<String, List<TransactionList>> _groupTransactionsBySubcategory(List<TransactionList> transactions) {
    final Map<String, List<TransactionList>> grouped = {};
    for (var transaction in transactions) {
      grouped.putIfAbsent(transaction.name ?? 'Other', () => []);
      grouped[transaction.name ?? 'Other']!.add(transaction);
    }
    return grouped;
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
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: groupedSubcategories.keys.length,
        itemBuilder: (context, index) {
          final subcategoryName = groupedSubcategories.keys.toList()[index];
          final subcategoryTransactions = groupedSubcategories[subcategoryName]!;
          final totalAmount = subcategoryTransactions.fold<double>(
            0,
                (sum, transaction) => sum + (transaction.amount ?? 0),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
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
                  backgroundColor: subcategoryTransactions.first.iconColor,
                  child: Icon(
                    subcategoryTransactions.first.iconData,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  subcategoryName,
                  style:  TextStyle(fontWeight: FontWeight.bold,          color: isDarkMode ? Colors.white : Colors.black, // Back arrow color
                  ),
                ),
                subtitle: Text(
                  '${subcategoryTransactions.length} Transaction${subcategoryTransactions.length > 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Text(
                  '-RM ${totalAmount.toStringAsFixed(2)}',
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
                      builder: (context) => SubCategoryDetailScreen(
                        userid: widget.userid,
                        subcategoryName: subcategoryName,
                        transactions: subcategoryTransactions,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}