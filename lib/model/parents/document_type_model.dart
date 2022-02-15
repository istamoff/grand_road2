class DocumentTypeModel {
  DocumentTypeModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) => DocumentTypeModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory DocumentTypeModel.empty() =>
      DocumentTypeModel(count: 0, next: "", previous: "", results: []);
  
}

class Result {
  Result({
    required this.id,
    required this.title,
    required this.isOther,
  });

  int id;
  String title;
  bool isOther;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
    isOther: json["is_other"] == null ? false : json["is_other"],
  );

  factory Result.empty() =>
      Result(id: 0, title : "", isOther: false);
}
