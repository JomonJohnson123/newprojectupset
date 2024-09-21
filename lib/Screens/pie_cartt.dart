import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

class OverviewPage extends StatelessWidget {
  OverviewPage({super.key});

  // Sample data for the PieChart
  final Map<String, double> dataMap = {
    "Category A": 40,
    "Category B": 30,
    "Category C": 20,
    "Category D": 10,
  };

  // Sample color list for the PieChart
  final List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 220, 220),
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: 'Overview',
        onBackPressed: () => Navigator.pop(context),
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70.0),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: PieChart(
            dataMap: dataMap,
            chartType: ChartType.ring,
            baseChartColor: Colors.grey[300]!,
            colorList: colorList,
          ),
        ),
      ),
    );
  }
}
