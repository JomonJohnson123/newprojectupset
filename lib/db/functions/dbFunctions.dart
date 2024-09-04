import 'dart:io';
import 'package:hive/hive.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

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
