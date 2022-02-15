import 'package:equatable/equatable.dart';

class ChildGroupModel extends Equatable{
  final List<GroupModel> list;
  ChildGroupModel({required this.list});

  factory ChildGroupModel.fromJson(List<dynamic> parsedJson) {

    List<GroupModel> list =  parsedJson.map((e) => GroupModel.fromJson(e)).toList();
    return ChildGroupModel(
      list: list,
    );
  }

  factory ChildGroupModel.empty() => ChildGroupModel(list: []);

  @override
  List<Object?> get props => [list];


}



class GroupModel {
  GroupModel({
    required this.id,
    required this.title,
    required this.className,
  });

  int id;
  String title;
  ClassName className;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
    className: json["class_name"] == null ? ClassName.empty() : ClassName.fromJson(json["class_name"]),
  );

  factory GroupModel.empty() => GroupModel(id: 0, title: "", className: ClassName.empty());
}

class ClassName {
  ClassName({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory ClassName.fromJson(Map<String, dynamic> json) => ClassName(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
  );

  factory ClassName.empty() => ClassName(id: 0, title: "");
}

