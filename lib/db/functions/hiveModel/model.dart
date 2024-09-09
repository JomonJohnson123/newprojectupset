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

@HiveType(typeId: 2)
class Categorymodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String imagepath;

  @HiveField(2)
  String categoryname;

  Categorymodel({required this.imagepath, this.id, required this.categoryname});
}

@HiveType(typeId: 3)
class Productmodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? image;

  @HiveField(2)
  String? productname;

  @HiveField(3)
  String? categoryname;

  @HiveField(4)
  String? description;

  @HiveField(5)
  int? sellingrate;

  @HiveField(6)
  int? purchaserate;

  @HiveField(7)
  int? stock;

  Productmodel({
    this.id,
    required this.image,
    required this.productname,
    required this.categoryname,
    required this.description,
    required this.sellingrate,
    required this.purchaserate,
    required this.stock,
  });
}
