import 'package:equatable/equatable.dart';

class ChildClassModel  extends Equatable{
  ChildClassModel ({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<ResultClass> results;

  factory ChildClassModel .fromJson(Map<String, dynamic> json) => ChildClassModel (
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<ResultClass>.from(json["results"].map((x) => ResultClass.fromJson(x))),
  );

  factory ChildClassModel .empty() => ChildClassModel (count: 0, next: "", previous: "", results: []);

  @override
  // TODO: implement props
  List<Object?> get props => [count, next, previous, results];

}

class ResultClass {
  ResultClass({
    required this.id,
    required this.createdDate,
    required this.modifiedDate,
    required this.title,
  });

  int id;
  DateTime createdDate;
  DateTime modifiedDate;
  String title;

  factory ResultClass.fromJson(Map<String, dynamic> json) => ResultClass(
    id: json["id"] == null ? 0 : json["id"],
    createdDate: json["created_date"] == null ? DateTime(0) : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? DateTime(0) : DateTime.parse(json["modified_date"]),
    title: json["title"] == null ? "" : json["title"],
  );

  factory ResultClass.empty() =>
      ResultClass(id: 0, title: "", createdDate: DateTime(0), modifiedDate: DateTime(0));

}


