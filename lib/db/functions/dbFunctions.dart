// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, duplicate_ignore, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

ValueNotifier<List<Userdatamodel>> userListNotifier = ValueNotifier([]);
ValueNotifier<List<Categorymodel>> categoryListNotifier = ValueNotifier([]);
ValueNotifier<List<Productmodel>> productListNotifier = ValueNotifier([]);
ValueNotifier<double> totalPriceNotifier = ValueNotifier<double>(0.0);
ValueNotifier<int> productCountNotifier = ValueNotifier(0);

calculateTotalPrice({DateTime? selectedDate}) {
  double totalPrice = 0.0;

  // If no date is selected, calculate the total price for all products
  if (selectedDate == null) {
    for (var sellProduct in sellListNotifier.value) {
      double? price = double.tryParse(sellProduct.sellPrice.toString());
      if (price != null) {
        totalPrice += price;
      }
    }
  } else {
    // If a date is selected, calculate the total price for that specific date
    for (var sellProduct in sellListNotifier.value) {
      if (sellProduct.sellDate != null &&
          DateFormat('yyyy-MM-dd').format(sellProduct.sellDate!) ==
              DateFormat('yyyy-MM-dd').format(selectedDate)) {
        double? price = double.tryParse(sellProduct.sellPrice.toString());
        if (price != null) {
          totalPrice += price;
        }
      }
    }
  }

  // Update the total price notifier to trigger UI rebuild
  totalPriceNotifier.value = totalPrice;
}

Future<void> addproducts(Productmodel value, String categoryid) async {
  await IDGenerator2.initialize();
  final productBox = await Hive.openBox<Productmodel>('product_db');
  int id = IDGenerator2.generateUniqueID();
  value.id = id;
  value.categoryname = categoryid;
  final addedid = productBox.add(value);
  print('generated id: $id');

  // ignore: unnecessary_null_comparison
  if (addedid != null) {
    productListNotifier.value = [...productListNotifier.value, value];
    productListNotifier.notifyListeners();
  }
}

Future<void> initializeProductCount() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');

  // Set the initial product count
  productCountNotifier.value = productBox.length;

  // Listen for changes in the product box
  productBox.watch().listen((event) {
    // Update the product count whenever a change occurs
    productCountNotifier.value = productBox.length;
  });
}

// Function to retrieve the product count synchronously (if needed)
Future<int> getTotalProductCount() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  return productBox.length;
}

Future<void> getallproduct() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final categoryList = List<Productmodel>.from(productBox.values);
  productListNotifier.value = [...categoryList];
  productListNotifier.notifyListeners();
}

class IDGenerator {
  static const String _counterBoxKey = 'counterBoxKey';
  static late Box<int> _counterBox;

  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

// User functions
Future<void> addSignUp(Userdatamodel value) async {
  // ignore: duplicate_ignore
  try {
    await IDGenerator.initialize();
    final chairDB = await Hive.openBox<Userdatamodel>('login_db');
    final idd = IDGenerator.generateUniqueID();
    value.id = idd;
    await chairDB.put(idd, value);
    userListNotifier.value.add(value);
    chairDB.close();
    // ignore: invalid_use_of_protected_member
    userListNotifier.notifyListeners();
  } catch (error) {
    print('Error adding user: $error');
  }
}

Future<void> getAll() async {
  try {
    final chairDB = await Hive.openBox<Userdatamodel>('login_db');

    userListNotifier.value.clear();
    userListNotifier.value.addAll(chairDB.values);
    // ignore: invalid_use_of_protected_member
    userListNotifier.notifyListeners();
  } catch (error) {
    print('Error retrieving users: $error');
  }
}

// Category functions
Future<void> addCategory(Categorymodel category) async {
  final categoryBox = await Hive.openBox<Categorymodel>('categories');
  await categoryBox.add(category);

  // Notify listeners to update the UI
  categoryListNotifier.value = categoryBox.values.toList();
  categoryListNotifier.notifyListeners();
}

Future<void> getAllCategories() async {
  final categoryBox = await Hive.openBox<Categorymodel>('categories');
  categoryListNotifier.value = categoryBox.values.toList();
}

Future<void> deletectgrs(int categoryId) async {
  final categoryBox = await Hive.openBox<Categorymodel>('categories');
  await categoryBox.delete(categoryId);

  // Update and notify listeners
  categoryListNotifier.value = categoryBox.values.toList();
  categoryListNotifier.notifyListeners();
}

Future<void> updatectgrs(int id, Categorymodel updatedCategory) async {
  try {
    final categoryDB = await Hive.openBox<Categorymodel>('category_db');

    // Check if the category with the given id exists
    if (categoryDB.containsKey(id)) {
      await categoryDB.put(id, updatedCategory); // Update the category
      int index =
          categoryListNotifier.value.indexWhere((data) => data.id == id);
      if (index != -1) {
        categoryListNotifier.value[index] =
            updatedCategory; // Update the category in the notifier list
        // Notify listeners of the change
      }
      categoryListNotifier.notifyListeners();
    } else {
      print('Category with id $id does not exist');
    }
  } catch (error) {
    // ignore: avoid_print
    print('Error updating category: $error');
  }
}

class IDGenerator2 {
  static const String _counterBoxKey = 'counterBoxkey2';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

class IDGeneratorbill {
  static const String _counterBoxKey = 'counterBoxkey3';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

Future<void> editproduct(int id, Productmodel updatedData) async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final existingData = productBox.get(id);

  if (existingData != null) {
    existingData.productname = updatedData.productname;
    existingData.description = updatedData.description;
    existingData.image = updatedData.image;
    existingData.sellingrate = updatedData.sellingrate;
    existingData.purchaserate = updatedData.purchaserate;
    existingData.stock = updatedData.stock;
    existingData.categoryname = updatedData.categoryname;

    // Update the product in the Hive box
    productBox.put(id, existingData);

    // Update the product in the productListNotifier
    int index = productListNotifier.value.indexWhere((data) => data.id == id);
    if (index != -1) {
      productListNotifier.value[index] = existingData;
      productListNotifier.notifyListeners();
    }
  }
}

Future<void> deleteproduct(int id) async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  await productBox.delete(id);
  await getallproduct();
  await productBox.close();
}

ValueNotifier<List<SellProduct>> sellListNotifier = ValueNotifier([]);

Future<void> addSellProduct(
  SellProduct value,
) async {
  try {
    final sellBox = await Hive.openBox<SellProduct>(
        'sell_products'); // Changed 'students' to 'sell_products'
    final id = await sellBox.add(value);
    value.id = id;
    sellListNotifier.value = sellBox.values.toList();
    sellListNotifier.notifyListeners();
    print('Sell product added: $value');
  } catch (e) {
    print('Error adding sell product: $e');
  }
}

Future<void> getsellproduct() async {
  final studentBox = await Hive.openBox<SellProduct>('sell_products');
  sellListNotifier.value.clear();
  sellListNotifier.value.addAll(studentBox.values);
  sellListNotifier.notifyListeners();
  print('Retrieved sell products: ${sellListNotifier.value}');
}

double calculateTotalAmount(List<SellProduct> sellProducts) {
  double totalAmount = 0.0;
  for (var sellProduct in sellProducts) {
    // Safely convert the sellPrice to double in case it's stored as a String
    totalAmount += double.tryParse(sellProduct.sellPrice.toString()) ?? 0.0;
  }
  return totalAmount;
}

//selldetails.......
class UserDataService {
  Future<Userdatamodel?> retrieveUserData() async {
    final box = Hive.box<Userdatamodel>('create_account');
    if (box.isNotEmpty) {
      // Assuming you want the first user or modify logic accordingly
      return box.getAt(1);
    }
    return null;
  }
}

// void getUserData() async {
//   final Box = Hive.box<Userdatamodel>('create_account');
//   final List<Userdatamodel> users = Box.values.toList();
//   print(users);
// }
