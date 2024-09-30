// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, duplicate_ignore

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

// ValueNotifiers for counts
ValueNotifier<int> totalProductsNotifier = ValueNotifier(0);
ValueNotifier<int> totalSoldProductsNotifier = ValueNotifier(0);
ValueNotifier<int> totalCategoriesNotifier = ValueNotifier(0);

Future<void> getallproduct() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final productList = List<Productmodel>.from(productBox.values);
  productListNotifier.value = productList;

  totalProductsNotifier.value = productList.length;

  // ignore: invalid_use_of_protected_member
  productListNotifier.notifyListeners();
}

Future<void> getsellproduct() async {
  final studentBox = await Hive.openBox<SellProduct>('sell_products');
  sellListNotifier.value.clear();
  sellListNotifier.value.addAll(studentBox.values);

  // Update total sold product count
  totalSoldProductsNotifier.value = sellListNotifier.value.length;

  // Notify listeners
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
  // Ignore unnecessary null comparison
  // ignore: unnecessary_null_comparison
  if (selectedDate != null) {
    return sellListNotifier.value
        .where((sellProduct) =>
            sellProduct.sellDate != null &&
            DateFormat('yyyy-MM-dd').format(sellProduct.sellDate!) ==
                DateFormat('yyyy-MM-dd').format(selectedDate!))
        .length;
  } else {
    return sellListNotifier.value.length;
  }
}

// Update counts after a change in the database
Future<void> updateCounts() async {
  totalProductsNotifier.value = await getTotalProductCount();
  totalSoldProductsNotifier.value = countSalesBills();
  totalCategoriesNotifier.value = await getTotalCategoryCount();
}

// Example when adding a product
Future<void> addProduct(Productmodel product) async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  await productBox.add(product);
  await updateCounts(); // Refresh counts after adding a product
}

// Example when selling a product
Future<void> sellProduct(SellProduct product) async {
  final sellBox = await Hive.openBox<SellProduct>('sell_products');
  await sellBox.add(product);
  await updateCounts(); // Refresh counts after selling a product
}
