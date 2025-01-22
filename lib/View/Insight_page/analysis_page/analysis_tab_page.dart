import 'dart:typed_data';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Model/Analysis.dart';
import '../../../Model/SignupLoginPage_model.dart';
import '../../../ViewModel/AnalysisViewModel.dart';
import '../../../ViewModel/DateViewModel.dart';
import '../../../ViewModel/app_appearance_viewmodel.dart';


class Analysis extends StatefulWidget{
  final UserInfoModule userInfo;
  const Analysis({super.key,required this.userInfo});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  int _currentIndex = 0;
  String activeTab = "Overall"; // Default active tab
  String selectedDate = DateFormat('MMMM yyyy').format(DateTime.now());
  late int userid;

  @override
  void initState() {
    super.initState();
    userid = widget.userInfo.id;
    // Fetch budget data when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dateViewModel = context.read<DateViewModel>();
      Provider.of<AnalysisViewModel>(context, listen: false).fetchAnalysis(userid, dateViewModel.yearMonthDay);
    });
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
                      child: activeTab == "Overall"? Column(
                        children: [
                          BudgetVsRealPieChart(
                            currentIndex: _currentIndex,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index; // Update the current index
                              });
                            },
                            analysis: viewModel.analysis,
                            totalBudget: viewModel.totalBudget,
                            totalExpense: viewModel.totalExpense,
                          ),
                          SizedBox(height: 16), // Space between the carousel and the indicators
                          _buildDotIndicators(),
                        ],
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
                        child: viewModel.jsonRespose != null
                            ? MessageBox(savingMaximization: viewModel.jsonRespose!)
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

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index ? Colors.teal : Colors.grey,
          ),
        );
      }),
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

  final List<AnalysisData> analysis;

  BudgetVsRealChart({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);    // Calculate the width based on the number of data points
    double analysisWidth = analysis.length * 150.0; // 80px per data point

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: analysisWidth, // Set the width of the chart container
        child: SfCartesianChart(
          legend: Legend(
            isVisible: true,
            // Border color and border width of legend
            borderColor: Colors.green,
            borderWidth: 2,
            alignment: ChartAlignment.near,
            textStyle: TextStyle(color: isDarkMode ? Colors.white :  Colors.black),
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
                textStyle: TextStyle(color:isDarkMode ? Colors.white :  Colors.black,
                ),
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
                textStyle: TextStyle(color:isDarkMode ? Colors.white :  Colors.black),
              ),
            ),
          ],
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black, // Category name text color
              fontWeight: FontWeight.bold,
            ),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black, // Y-axis label text color
            ),
          ),
        ),
      ),
    );
  }
}

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
          fontSize: 18.0,
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final Map<String, dynamic> savingMaximization;

  MessageBox({
    super.key,
    required this.savingMaximization,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Text(
          'Saving Maximization',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white :  Colors.black,
          ),
        ),
        const SizedBox(height: 16), // Spacing between title and content
        // Background Box with Text Content
        Container(
          margin: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 48.0, right: 48.0),
          padding: const EdgeInsets.all(16.0), // Inner padding for the text
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Light gray background color
            borderRadius: BorderRadius.circular(45.0), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Problem',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                savingMaximization['Problem'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                savingMaximization['Recommendations'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Action',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                savingMaximization['Action'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BudgetVsRealPieChart extends StatelessWidget {
  final List<AnalysisData> analysis;
  final double totalBudget;
  final double totalExpense;
  final int currentIndex; // Current index of the carousel
  final Function(int) onPageChanged; // Callback to update the index

  BudgetVsRealPieChart({
    super.key,
    required this.analysis,
    required this.totalBudget,
    required this.totalExpense,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.black : const Color(0xFF65ADAD);
    final highlightColor = isDarkMode ? Colors.teal : const Color(0xFF65ADAD);    return CarouselSlider(
      options: CarouselOptions(
        height: 500, // Set the height of the carousel
        enlargeCenterPage: true,
        autoPlay: false,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
        //autoPlayInterval: Duration(seconds: 3),
        onPageChanged: (index, reason) {
          onPageChanged(index); // Call the callback to update the index
        },
      ),
      items: [
        _buildPieChart(
          isDarkMode: isDarkMode,
          title: 'Budget\nTotal: RM ${totalBudget.toStringAsFixed(2)}',
          dataSource: analysis,
          valueMapper: (AnalysisData data, _) => data.budget_amount,
        ),
        _buildPieChart(
          isDarkMode: isDarkMode,
          title: 'Actual Expenses\nTotal: RM ${totalExpense.toStringAsFixed(2)}',
          dataSource: analysis,
          valueMapper: (AnalysisData data, _) => data.expense_amount,
        ),
      ],
    );
  }

  Widget _buildPieChart({
    required bool isDarkMode,
    required String title,
    required List<AnalysisData> dataSource,
    required ChartValueMapper<AnalysisData, num> valueMapper,
  }) {

    return SfCircularChart(
      title: ChartTitle(
        text: title,
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold, // Make the title bold

        ),
      ),
      legend: Legend(
        isVisible: true,
        borderColor:  isDarkMode ? Colors.white :  Colors.black,

        borderWidth: 2,
        legendItemBuilder: (String name, ChartSeries<dynamic, dynamic>? series, ChartPoint<dynamic> point, int index) {
          final data = dataSource[index]; // Get the corresponding data
          return Row(
            children: [
              Icon(
                IconData(data.codepoint, fontFamily: data.fontfamily), // Use the dynamically generated icon
                size: 18,
                color: Color(data.color), // Use the dynamically assigned color
              ),
              SizedBox(width: 8), // Space between icon and text
              Text(
                name, // Display the category name
                style: TextStyle(
                  color: isDarkMode ? Colors.white :  Colors.black,
                  fontSize: 18, // Set the font size for the category labels
                  fontWeight: FontWeight.bold, // Optional: make the labels bold
                ),
              ),
            ],
          );
        },
      ),
      series: <CircularSeries>[
        PieSeries<AnalysisData, String>(
          dataSource: dataSource,
          pointColorMapper: (AnalysisData data, _) => Color(data.color),
          xValueMapper: (AnalysisData data, _) => data.category_name,
          yValueMapper: valueMapper,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(
             color:  isDarkMode ? Colors.white :  Colors.black,

              fontSize: 18, // Set the font size for the category labels
            ),
          ),
        ),
      ],
    );
  }
}