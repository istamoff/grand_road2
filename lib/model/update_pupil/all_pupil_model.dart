import 'package:equatable/equatable.dart';

class AllPupilModel extends Equatable{
  AllPupilModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory AllPupilModel.fromJson(Map<String, dynamic> json) => AllPupilModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory AllPupilModel.empty() =>
      AllPupilModel(count: 0, next: "", previous: "", results: []);

  @override
  // TODO: implement props
  List<Object?> get props => [count, next, previous, results];

}

class Result {
  Result({
    required this.id,
    required this.photo,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.address,
    required this.birthDate,
    required this.genderType,
    required this.humans,
    required this.childGroup,
    required this.childClass,
  });

  int id;
  String photo;
  String fullName;
  String firstName;
  String lastName;
  String middleName;
  String address;
  DateTime birthDate;
  String genderType;
  List<dynamic> humans;
  String childGroup;
  String childClass;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    photo: json["photo"] == null ? "" : json["photo"],
    fullName: json["full_name"] == null ? "" : json["full_name"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    address: json["address"] == null ? "" : json["address"],
    birthDate: json["birth_date"] == null ? DateTime(0) : DateTime.parse(json["birth_date"]),
    genderType: json["gender_type"] == null ? "" : json["gender_type"],
    humans: json["humans"] == null ? [] : List<dynamic>.from(json["humans"].map((x) => x)),
    childGroup: json["child_group"] == null ? "" : json["child_group"],
    childClass: json["child_class"] == null ? "" : json["child_class"],
  );

  factory Result.empty() =>
      Result(id: 0, photo: "", fullName: "", firstName: "", lastName: "", address: "", birthDate: DateTime(0), genderType: "", humans: [],
      childGroup: "", childClass: "", middleName: "");


}
