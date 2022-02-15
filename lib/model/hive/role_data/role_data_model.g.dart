// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoleDataModelAdapter extends TypeAdapter<RoleDataModel> {
  @override
  final int typeId = 1;

  @override
  RoleDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoleDataModel(
      id: fields[0] as int,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      fullName: fields[3] as String,
      userName: fields[4] as String,
      language: fields[5] as String,
      roleUz: fields[6] as String,
      roleRu: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoleDataModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.userName)
      ..writeByte(5)
      ..write(obj.language)
      ..writeByte(6)
      ..write(obj.roleUz)
      ..writeByte(7)
      ..write(obj.roleRu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
