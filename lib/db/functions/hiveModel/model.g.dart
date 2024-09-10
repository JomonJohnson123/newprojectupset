// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserdatamodelAdapter extends TypeAdapter<Userdatamodel> {
  @override
  final int typeId = 1;

  @override
  Userdatamodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Userdatamodel(
      id: fields[0] as int?,
      name: fields[1] as String,
      username: fields[2] as String,
      password: fields[3] as String,
      email: fields[4] as String,
      mobile: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Userdatamodel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.mobile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserdatamodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 2;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as int?,
      image: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategorymodelAdapter extends TypeAdapter<Categorymodel> {
  @override
  final int typeId = 3;

  @override
  Categorymodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categorymodel(
      imagepath: fields[1] as String,
      id: fields[0] as int?,
      categoryname: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Categorymodel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagepath)
      ..writeByte(2)
      ..write(obj.categoryname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategorymodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductmodelAdapter extends TypeAdapter<Productmodel> {
  @override
  final int typeId = 4;

  @override
  Productmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Productmodel(
      id: fields[0] as int?,
      image: fields[1] as String?,
      productname: fields[2] as String?,
      categoryname: fields[3] as String?,
      description: fields[4] as String?,
      sellingrate: fields[5] as int?,
      purchaserate: fields[6] as int?,
      stock: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Productmodel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.productname)
      ..writeByte(3)
      ..write(obj.categoryname)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.sellingrate)
      ..writeByte(6)
      ..write(obj.purchaserate)
      ..writeByte(7)
      ..write(obj.stock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
