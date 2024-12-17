import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';

class Analysis extends StatefulWidget{
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  String activeTab = "Overall"; // Default active tab
  String selectedDate = DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 16.0), // Adjust padding as needed
              child: DatePickerButton(
                  dateText: selectedDate,
                  onDatePicked: (DateTime newDate) {
                    setState(() {
                      selectedDate = DateFormat("MMMM yyyy").format(newDate);
                    });
                  },
              ),
            )),
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 16.0), // Adjust padding as needed
              child: activeTab == "Overall"? BudgetVsRealPieChart() : BudgetVsRealChart(),
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
            Center(child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 16.0, right: 16.0, bottom: 16.0), // Add some padding around the component
                child: MessageBox()
            )),
          ],
        ),
      ),
    );
  }


}

class DatePickerButton extends StatelessWidget {
  final String dateText;
  final Function(DateTime) onDatePicked;

  const DatePickerButton({
    super.key,
    required this.dateText,
    required this.onDatePicked,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? initialDate;
    try {
      initialDate = DateTime.parse(dateText);
    } catch (e) {
      initialDate = DateTime.now();
    }

    DateTime? picked = await showMonthYearPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDate: initialDate, // Set initial date
    );

    if (picked != null) {
      onDatePicked(picked); // Trigger callback with the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
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
  final List<ChartData> chartData = [
    ChartData(category: 'Jan', budget: 1000, actual: 800),
    ChartData(category: 'Feb', budget: 1200, actual: 1150),
    ChartData(category: 'Mar', budget: 1500, actual: 1400),
    ChartData(category: 'Apr', budget: 1000, actual: 800),
    ChartData(category: 'May', budget: 1200, actual: 1500),
    ChartData(category: 'Jun', budget: 1500, actual: 1300),
    ChartData(category: 'Jul', budget: 1000, actual: 800),
    ChartData(category: 'Aug', budget: 1200, actual: 1100),
    ChartData(category: 'Sep', budget: 1500, actual: 1300),
    // ... more data points
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the width based on the number of data points
    double chartWidth = chartData.length * 150.0; // 80px per data point

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth, // Set the width of the chart container
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
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.budget,
              name: 'Budget',
              color: Colors.blue,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
              ),
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.actual,
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

class ChartData {
  ChartData({required this.category, required this.budget, required this.actual});
  final String category;
  final double budget;
  final double actual;
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
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  String text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. "
      "Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. "
      "Donec quam felis, ultricies nec, pellentesque eu Lorem ipsum dolor sit amet, consectetuer adipiscing elit. "
      "Aenean commodo ligula eget dolor. Aenean massa. "
      "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. "
      "Donec quam felis, ultricies nec, pellentesque eu";

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
          child: Text(text),
        )
      ],
    );
  }
}

class PieChartData {
  PieChartData({required this.category, required this.value});
  final String category;
  final double value;
}

class BudgetVsRealPieChart extends StatelessWidget {
  final List<PieChartData> budgetData = [
    PieChartData(category: 'Category 1', value: 100),
    PieChartData(category: 'Category 2', value: 200),
    PieChartData(category: 'Category 3', value: 100),
    PieChartData(category: 'Category 4', value: 200),
  ];

  final List<PieChartData> actualData = [
    PieChartData(category: 'Category 1', value: 80),
    PieChartData(category: 'Category 2', value: 180),
    PieChartData(category: 'Category 3', value: 80),
    PieChartData(category: 'Category 4', value: 180),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SfCircularChart(
            title: ChartTitle(text: 'Budget\nTotal: ${calculateTotal(budgetData)}'),
            legend: Legend(
                isVisible: true,
                // Border color and border width of legend
                borderColor: Colors.black,
                borderWidth: 2
            ),
            series: <CircularSeries>[
              PieSeries<PieChartData, String>(
                dataSource: budgetData,
                xValueMapper: (PieChartData data, _) => data.category,
                yValueMapper: (PieChartData data, _) => data.value,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                ),
              ),
            ],
          ),
          SfCircularChart(
            title: ChartTitle(text: 'Actual Expenses\nTotal: ${calculateTotal(actualData)}'),
            legend: Legend(
                isVisible: true,
                // Border color and border width of legend
                borderColor: Colors.black,
                borderWidth: 2
            ),
            series: <CircularSeries>[
              PieSeries<PieChartData, String>(
                dataSource: actualData,
                xValueMapper: (PieChartData data, _) => data.category,
                yValueMapper: (PieChartData data, _) => data.value,
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

  // Function to calculate the total sum
  double calculateTotal(List<PieChartData> data) {
    return data.fold(0, (sum, item) => sum + item.value);
  }
}