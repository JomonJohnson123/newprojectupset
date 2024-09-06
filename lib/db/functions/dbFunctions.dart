import 'dart:io';
import 'package:hive/hive.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

////////////////CATEGORY HANDLING DATABASE....../////
class CategoryService {
  static const String _categoryBoxName = 'categoryBox';

  Future<void> initHive() async {
    await Hive.openBox<CategoryModel>(_categoryBoxName);
  }

  Future<void> addCategory(String name, File image) async {
    final box = Hive.box<CategoryModel>(_categoryBoxName);
    final category = CategoryModel(
      categoryname: name,
      ctgimage: image.path,
    );
    await box.add(category);
  }

  List<CategoryModel> getCategories() {
    final box = Hive.box<CategoryModel>(_categoryBoxName);
    return box.values.toList();
  }

  Future<void> deleteCategory(int index) async {
    final box = Hive.box<CategoryModel>(_categoryBoxName);
    await box.deleteAt(index);
  }
}

////////////////PRODUCT HANDLING DATABASE....../////

class ProductService {
  final String _boxName = 'productsBox';

  Future<void> addProduct(ProductModel product) async {
    var box = await Hive.openBox<ProductModel>(_boxName);
    await box.add(product);
  }

  Future<List<ProductModel>> getAllProducts() async {
    var box = await Hive.openBox<ProductModel>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteProduct(int index) async {
    var box = await Hive.openBox<ProductModel>(_boxName);
    await box.deleteAt(index);
  }
}

class ProductSearchService {
  List<ProductModel> searchProducts(
      String searchText, List<ProductModel> products) {
    searchText = searchText.toLowerCase();
    return products.where((product) {
      return product.productname.toLowerCase().contains(searchText);
    }).toList();
  }
}
