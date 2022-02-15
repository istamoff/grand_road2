import 'package:hive/hive.dart';

part 'role_data_model.g.dart';

@HiveType(typeId: 1)
class RoleDataModel {
  RoleDataModel({
     required this.id,
     required this.firstName,
     required this.lastName,
     required this.fullName,
     required this.userName,
     required this.language,
     required this.roleUz,
     required this.roleRu
  });
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String firstName;
  @HiveField(2)
  late String lastName;
  @HiveField(3)
  late String fullName;
  @HiveField(4)
  late String userName;
  @HiveField(5)
  late String language;
  @HiveField(6)
  late String roleUz;
  @HiveField(7)
  late String roleRu;

  factory RoleDataModel.empty() =>
      RoleDataModel(id: 0, firstName: "", lastName: "",
          fullName: "",  userName: "", language: "", roleUz: "", roleRu: ""
      );
}
