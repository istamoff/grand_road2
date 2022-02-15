
class ChildGroupModel{
  final List<RelativeTypeModel> list;
  ChildGroupModel({required this.list});

  factory ChildGroupModel.fromJson(List<dynamic> parsedJson) {

    List<RelativeTypeModel> list = [];
    list = parsedJson.map((e) => RelativeTypeModel.fromJson(e)).toList();
    return ChildGroupModel(
      list: list,
    );
  }

  factory ChildGroupModel.empty() => ChildGroupModel(list: []);

}

// import 'dart:convert';
// List<RelativeTypeModel> relativeTypeModelFromJson(String str) => List<RelativeTypeModel>.from(json.decode(str).map((x) => RelativeTypeModel.fromJson(x)));


class RelativeTypeModel {
  RelativeTypeModel({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory RelativeTypeModel.fromJson(Map<String, dynamic> json) => RelativeTypeModel(
    id: json["id"] == null ? "" : json["id"],
    title: json["title"] == null ? "" : json["title"],
  );

  factory RelativeTypeModel.empty() =>
      RelativeTypeModel(id: 0, title : "");
}
