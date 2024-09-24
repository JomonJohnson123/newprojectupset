// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

Future<void> getallproduct() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final productList = List<Productmodel>.from(productBox.values);
  productListNotifier.value = productList;

  // ignore: invalid_use_of_protected_member
  productListNotifier.notifyListeners();
}

Future<void> getsellproduct() async {
  final studentBox = await Hive.openBox<SellProduct>('sell_products');
  sellListNotifier.value.clear();
  sellListNotifier.value.addAll(studentBox.values);
  // ignore: invalid_use_of_protected_member
  sellListNotifier.notifyListeners();
  // ignore: avoid_print
  print('Retrieved sell products: ${sellListNotifier.value}');
}

Future<int> getTotalProductCount() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  return productBox.length;
}

Future<int> getTotalCategoryCount() async {
  final categoryBox = await Hive.openBox('category_db');
  return categoryBox.length;
}

int countSalesBills() {
  DateTime? selectedDate;
  // ignore: unnecessary_null_comparison
  if (selectedDate != null) {
    // Count sales bills for the selected date
    return sellListNotifier.value
        .where((sellProduct) =>
            sellProduct.sellDate != null &&
            DateFormat('yyyy-MM-dd').format(sellProduct.sellDate!) ==
                DateFormat('yyyy-MM-dd').format(selectedDate!))
        .length;
  } else {
    // Count all sales bills if no date is selected
    return sellListNotifier.value.length;
  }
}
