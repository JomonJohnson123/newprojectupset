import 'package:hive/hive.dart';

// Open Hive box for total sale amount
Future<Box<double>> openTotalSaleBox() async {
  return await Hive.openBox<double>('total_sale_box');
}

// Retrieve total sale amount from Hive
Future<double?> getTotalSaleAmount(Box<double> totalSaleBox) async {
  return totalSaleBox.get('total_sale');
}

// Store total sale amount in Hive
Future<void> storeTotalSaleAmount(
    Box<double> totalSaleBox, double totalSale) async {
  await totalSaleBox.put('total_sale', totalSale);
}
