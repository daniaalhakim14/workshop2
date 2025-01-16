import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Model/Analysis.dart';
import '../../../ViewModel/AnalysisViewModel.dart';
import '../../../ViewModel/DateViewModel.dart';


class Analysis extends StatefulWidget{
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  String activeTab = "Overall"; // Default active tab
  String selectedDate = DateFormat('MMMM yyyy').format(DateTime.now());
  int userid = 1;

  @override
  void initState() {
    super.initState();
    // Fetch budget data when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dateViewModel = context.read<DateViewModel>();
      Provider.of<AnalysisViewModel>(context, listen: false).fetchAnalysis(userid, dateViewModel.yearMonthDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<DateViewModel>(
              builder: (context, viewModel, child) {
                return Center(child: Padding(
                  padding: const EdgeInsets.only(top: 16.0), // Adjust padding as needed
                  child: DatePickerButton(
                    dateText: viewModel.formattedSelectedDate,
                    onTap: () {
                      final analysisViewModel = context.read<AnalysisViewModel>();
                      viewModel.selectDate(context).then((_) => {
                        analysisViewModel.fetchAnalysis(userid, viewModel.yearMonthDay)
                      });
                    },
                  ),
                ));
              },
            ),
            Consumer<AnalysisViewModel>(
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
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Center(child: Padding(
                      padding: const EdgeInsets.only(top: 16.0), // Adjust padding as needed
                      child: activeTab == "Overall"? BudgetVsRealPieChart(
                        analysis: viewModel.analysis,
                        totalBudget: viewModel.totalBudget,
                        totalExpense: viewModel.totalExpense,
                      ) : BudgetVsRealChart(
                        analysis: viewModel.analysis,
                      ),
                    )),
                    Center(child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Overall Tab Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeTab = "Overall";
                              });
                            },
                            child: TabButton(
                              text: "Overall",
                              isActive: activeTab == "Overall",
                            ),
                          ),
                          const SizedBox(width: 16), // Space between the buttons
                          // Category Tab Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                activeTab = "Category";
                              });
                            },
                            child: TabButton(
                              text: "Category",
                              isActive: activeTab == "Category",
                            ),
                          ),
                        ],
                      ),
                    )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, left: 16.0, right: 16.0, bottom: 16.0),
                        child: viewModel.savingMaximization != null
                            ? MessageBox(savingMaximization: viewModel.savingMaximization!)
                            : Container(),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerButton extends StatelessWidget {
  final String dateText;
  final VoidCallback onTap;

  const DatePickerButton({
    super.key,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateText,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.0),
            Icon(Icons.calendar_today, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class BudgetVsRealChart extends StatelessWidget {
  // final List<ChartData> chartData = [
  //   ChartData(category: 'Food', budget: 1000, actual: 800),
  //   ChartData(category: 'Transportation', budget: 1200, actual: 1150),
  //   ChartData(category: 'Shopping', budget: 1500, actual: 1400),
  //   ChartData(category: 'Entertainment', budget: 1000, actual: 800),
  //   ChartData(category: 'Healthcare', budget: 1200, actual: 1500),
  //   ChartData(category: 'Personal', budget: 1500, actual: 1300),
  //   ChartData(category: 'Education', budget: 1000, actual: 800),
  //   ChartData(category: 'Saving', budget: 1200, actual: 1100),
  //   ChartData(category: 'Others', budget: 1500, actual: 1300),
  //   // ... more data points
  // ];

  final List<AnalysisData> analysis;

  BudgetVsRealChart({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width based on the number of data points
    double analysisWidth = analysis.length * 150.0; // 80px per data point

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: analysisWidth, // Set the width of the chart container
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          legend: Legend(
            isVisible: true,
            // Border color and border width of legend
            borderColor: Colors.black,
            borderWidth: 2,
            alignment: ChartAlignment.near,
          ),
          series: <CartesianSeries>[
            ColumnSeries<AnalysisData, String>(
              dataSource: analysis,
              xValueMapper: (AnalysisData data, _) => data.category_name,
              yValueMapper: (AnalysisData data, _) => data.budget_amount,
              name: 'Budget',
              color: Colors.blue,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
              ),
            ),
            ColumnSeries<AnalysisData, String>(
              dataSource: analysis,
              xValueMapper: (AnalysisData data, _) => data.category_name,
              yValueMapper: (AnalysisData data, _) => data.expense_amount,
              name: 'Actual',
              color: Colors.red,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ChartData {
//   ChartData({required this.category, required this.budget, required this.actual});
//   final String category;
//   final double budget;
//   final double actual;
// }

// Custom TabButton Widget
class TabButton extends StatelessWidget {
  final String text;
  final bool isActive;

  const TabButton({super.key,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.teal : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final String savingMaximization;

  MessageBox({
    super.key,
    required this.savingMaximization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Text(
          'Saving Maximization',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16), // Spacing between title and content
        // Background Box with Text Content
        Container(
          padding: const EdgeInsets.all(16.0), // Inner padding for the text
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Light gray background color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          child: Text(savingMaximization),
        )
      ],
    );
  }
}

// class PieChartData {
//   PieChartData({required this.category, required this.value});
//   final String category;
//   final double value;
// }

class BudgetVsRealPieChart extends StatelessWidget {
  // final List<PieChartData> budgetData = [
  //   PieChartData(category: 'Category 1', value: 100),
  //   PieChartData(category: 'Category 2', value: 200),
  //   PieChartData(category: 'Category 3', value: 100),
  //   PieChartData(category: 'Category 4', value: 200),
  // ];
  //
  // final List<PieChartData> actualData = [
  //   PieChartData(category: 'Category 1', value: 80),
  //   PieChartData(category: 'Category 2', value: 180),
  //   PieChartData(category: 'Category 3', value: 80),
  //   PieChartData(category: 'Category 4', value: 180),
  // ];

  final List<AnalysisData> analysis;
  final double totalBudget;
  final double totalExpense;

  BudgetVsRealPieChart({
    super.key,
    required this.analysis,
    required this.totalBudget,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SfCircularChart(
            title: ChartTitle(text: 'Budget\nTotal: RM ${totalBudget.toStringAsFixed(2)}'),
            legend: Legend(
                isVisible: true,
                // Border color and border width of legend
                borderColor: Colors.black,
                borderWidth: 2
            ),
            series: <CircularSeries>[
              PieSeries<AnalysisData, String>(
                dataSource: analysis,
                xValueMapper: (AnalysisData data, _) => data.category_name,
                yValueMapper: (AnalysisData data, _) => data.budget_amount,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
              ),
            ],
          ),
          SfCircularChart(
            title: ChartTitle(text: 'Actual Expenses\nTotal: RM ${totalExpense.toStringAsFixed(2)}'),
            legend: Legend(
                isVisible: true,
                // Border color and border width of legend
                borderColor: Colors.black,
                borderWidth: 2
            ),
            series: <CircularSeries>[
              PieSeries<AnalysisData, String>(
                dataSource: analysis,
                xValueMapper: (AnalysisData data, _) => data.category_name,
                yValueMapper: (AnalysisData data, _) => data.expense_amount,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}