class ChildDocumentModel {
  ChildDocumentModel({
    required  this.count,
    required  this.next,
    required  this.previous,
    required  this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory ChildDocumentModel.fromJson(Map<String, dynamic> json) => ChildDocumentModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory ChildDocumentModel.empty() =>
      ChildDocumentModel(count: 0, next: "", previous: "", results: []);
}

class Result {
  Result({
    required  this.id,
    required  this.title,
    required  this.objectId,
    required  this.contentType,
    required  this.file,
    required  this.requiredFile,
  });

  int id;
  String title;
  int objectId;
  int contentType;
  String file;
  dynamic requiredFile;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
    objectId: json["object_id"] == null ? 0 : json["object_id"],
    contentType: json["content_type"] == null ? 0 : json["content_type"],
    file: json["file"] == null ? "" : json["file"],
    requiredFile: json["required_file"] == null ? "" : json["required_file"],
  );

  factory Result.empty() =>
      Result(title: "", id: 0, contentType: 0, file: "", objectId: 0, requiredFile: "");
}
