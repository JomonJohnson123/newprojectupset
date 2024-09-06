import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
class Userdatamodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  String email;

  @HiveField(5)
  int mobile;

  Userdatamodel({
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
    required this.mobile,
  });
}

@HiveType(typeId: 2)
class ProfileModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String image;

  ProfileModel({
    this.id,
    required this.image,
  });
}

@HiveType(typeId: 3)
class CategoryModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String categoryname;

  @HiveField(2)
  String ctgimage;

  CategoryModel({
    this.id,
    required this.categoryname,
    required this.ctgimage,
  });
}

@HiveType(typeId: 4)
class ProductModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String productname;

  @HiveField(2)
  String productimage;

  @HiveField(3)
  String productQuantity;

  @HiveField(4)
  String productPrice;

  @HiveField(5)
  String productDescription;

  ProductModel({
    this.id,
    required this.productname,
    required this.productimage,
    required this.productQuantity,
    required this.productPrice,
    required this.productDescription,
  });
}
