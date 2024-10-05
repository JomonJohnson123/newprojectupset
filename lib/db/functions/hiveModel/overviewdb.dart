import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';
// Import your models

// ValueNotifiers for counts
ValueNotifier<int> totalProductsNotifier = ValueNotifier(0);
ValueNotifier<int> totalSoldProductsNotifier = ValueNotifier(0);
ValueNotifier<int> totalCategoriesNotifier = ValueNotifier(0);

Future<void> updateCounts() async {
  totalProductsNotifier.value = await getTotalProductCount();
  totalSoldProductsNotifier.value = countSalesBills();
  totalCategoriesNotifier.value = await getTotalCategoryCount();

  // Notify listeners
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  totalProductsNotifier.notifyListeners();
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  totalSoldProductsNotifier.notifyListeners();
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  totalCategoriesNotifier.notifyListeners();
}

Future<int> getTotalProductCount() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  return productBox.length;
}

Future<int> getTotalCategoryCount() async {
  final categoryBox = await Hive.openBox('category_db');
  print('Category Count: ${categoryBox.length}'); // Debugging line
  return categoryBox.length;
}

Future<void> getallproduct() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final productList = List<Productmodel>.from(productBox.values);
  productListNotifier.value = productList;

  totalProductsNotifier.value = productList.length;

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  productListNotifier.notifyListeners();
}

Future<void> getsellproduct() async {
  final sellBox = await Hive.openBox<SellProduct>('sell_products');
  sellListNotifier.value.clear();
  sellListNotifier.value.addAll(sellBox.values);

  totalSoldProductsNotifier.value = sellListNotifier.value.length;

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  sellListNotifier.notifyListeners();
}

int countSalesBills() {
  DateTime? selectedDate;
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
