import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';

import 'package:upsets/db/functions/hiveModel/overviewdb.dart';
// Import the file with database functions

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Map<String, double> dataMap = {
    "Products": 0,
    "Selled products": 0,
    "Categories": 0,
  };

  final List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Fetch data asynchronously
    final totalProducts = await getTotalProductCount();
    final totalSoldProducts = countSalesBills();
    final totalCategories = await getTotalCategoryCount();

    // Update dataMap with real values
    setState(() {
      dataMap = {
        "Products": totalProducts.toDouble(),
        "Selled products": totalSoldProducts.toDouble(),
        "Categories": totalCategories.toDouble(),
      };
    });
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pie chart widget
            Card(
              elevation: 5,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PieChart(
                  dataMap: dataMap,
                  chartType: ChartType.ring,
                  baseChartColor: Colors.grey[300]!,
                  colorList: colorList,
                ),
              ),
            ),
            SizedBox(height: 30), // Space between pie chart and data map
            // Data map list view
            Expanded(
              child: ListView.builder(
                itemCount: dataMap.length,
                itemBuilder: (context, index) {
                  String category = dataMap.keys.elementAt(index);
                  double value = dataMap.values.elementAt(index);
                  Color categoryColor = colorList[index % colorList.length];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: categoryColor,
                      radius: 12,
                    ),
                    title: Text(category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    trailing: Text(
                      // ignore: unnecessary_string_interpolations
                      '${value.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
