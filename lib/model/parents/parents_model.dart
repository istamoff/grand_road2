class ParentsModel {
  ParentsModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory ParentsModel.fromJson(Map<String, dynamic> json) => ParentsModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" :  json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory ParentsModel.empty() =>
      ParentsModel(
      count: 0,
        results: [],
        previous: "",
        next: ""
      );

}

class Result {
  Result({
    required this.id,
    required this.photo,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.relativityType,
    required this.contacts,
    required this.files,
  });

  int id;
  String photo;
  String fullName;
  String firstName;
  String lastName;
  String middleName;
  RelativityType relativityType;
  List<String> contacts;
  List<dynamic> files;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    photo: json["photo"] == null ? "" : json["photo"],
    fullName: json["full_name"] == null ? "" : json["full_name"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    relativityType: json["relativity_type"] == null ? RelativityType.empty() : RelativityType.fromJson(json["relativity_type"]),
    contacts: json["contacts"] == null ? [] : List<String>.from(json["contacts"].map((x) => x)),
    files: json["files"] == null ? [] : List<dynamic>.from(json["files"].map((x) => x)),
  );


  factory Result.empty() =>
      Result(id: 0, photo: "", files: [], contacts: [], relativityType: RelativityType.empty(), middleName: "", lastName: "", firstName: "", fullName: "");
}

class RelativityType {
  RelativityType({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory RelativityType.fromJson(Map<String, dynamic> json) => RelativityType(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
  );


  factory RelativityType.empty() =>
      RelativityType(id: 0, title : "");
}
