
class MedicStatusModel{
  final List<StatusModel> list;
  MedicStatusModel({required this.list});

  factory MedicStatusModel.fromJson(List<dynamic> parsedJson) {

    List<StatusModel> list = [];
    list = parsedJson.map((e) => StatusModel.fromJson(e)).toList();
    return MedicStatusModel(
      list: list,
    );
  }
}


class StatusModel {
  StatusModel({
    required this.id,
    required this.title,
    required this.color,
  });

  int id;
  String title;
  String color;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "color": color,
  };
}
