// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, duplicate_ignore, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

ValueNotifier<List<Userdatamodel>> userListNotifier = ValueNotifier([]);
ValueNotifier<List<Categorymodel>> categoryListNotifier = ValueNotifier([]);
ValueNotifier<List<Productmodel>> productListNotifier = ValueNotifier([]);

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
Future<void> addCategory(Categorymodel value) async {
  try {
    await IDGenerator.initialize();
    final categoryDB = await Hive.openBox<Categorymodel>('category_db');

    // Assign unique id to the Categorymodel object
    value.id = IDGenerator.generateUniqueID();

    await categoryDB.put(
        value.id, value); // Add the Categorymodel object to the database
    categoryListNotifier.value
        .add(value); // Add the Categorymodel object to the notifier list

    categoryDB.close();
    categoryListNotifier.notifyListeners(); // Notify listeners of the change
  } catch (error) {
    print('Error adding category: $error');
  }
}

Future<void> getAllCategories() async {
  try {
    final categoryDB = await Hive.openBox<Categorymodel>('category_db');
    categoryListNotifier.value.clear();
    categoryListNotifier.value.addAll(categoryDB.values);
    categoryDB.close();
    categoryListNotifier.notifyListeners();
  } catch (error) {
    print('Error retrieving categories: $error');
  }
}

Future<void> deletectgrs(int id) async {
  IDGenerator.initialize();
  final categoryDB = await Hive.openBox<Categorymodel>('category_db');

  // Check if the category with the given id exists
  await categoryDB.delete(id); // Delete the category with the given id
  await getAllCategories(); // Refresh category list
  categoryDB.close();
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
