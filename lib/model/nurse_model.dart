import 'dart:convert';


class NurseModel {
  NurseModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory NurseModel.fromJson(Map<String, dynamic> json) => NurseModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );
  factory NurseModel.empty() =>
      NurseModel(
        count: 0,
        next: "",
        previous: "",
        results: []
      );
}

class Result {
  Result({
    required this.id,
    required this.comeInPerson,
    required this.comeInTime,
    required this.temperature,
    required this.status,
    required this.child,
    required this.comment,
  });

  int id;
  ComeInPerson comeInPerson;
  DateTime comeInTime;
  double temperature;
  Status status;
  Child child;
  String comment;


  factory Result.empty() => Result(
    id: 0,
    comeInPerson: ComeInPerson.empty(),
    comeInTime: DateTime(0),
    temperature: 0,
    status: Status.empty(),
    child: Child.empty(),
    comment: "",
  );


  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    comeInPerson: json["come_in_person"] == null ? ComeInPerson.empty() : ComeInPerson.fromJson(json["come_in_person"]),
    comeInTime: json["come_in_time"] == null ? DateTime(0) : DateTime.parse(json["come_in_time"]),
    temperature: json["temperature"] == null ? 0 : json["temperature"].toDouble(),
    status: json["status"] == null ? Status.empty() : Status.fromJson(json["status"]),
    child: json["child"] == null ? Child.empty() : Child.fromJson(json["child"]),
    comment: json["comment"] == null ? "" : json["comment"],
  );
}

class ComeInPerson {
  ComeInPerson({
    required this.id,
    required this.fullName,
    required this.phoneNumbers,
    required this.photo,
  });

  int id;
  String fullName;
  List<PhoneNumber> phoneNumbers;
  String photo;

  factory ComeInPerson.fromJson(Map<String, dynamic> json) => ComeInPerson(
    id: json["id"] == null ? 0 : json["id"],
    fullName: json["full_name"] == null ? "" : json["full_name"],
    phoneNumbers: json["phone_numbers"] == null ? [] : List<PhoneNumber>.from(json["phone_numbers"].map((x) => PhoneNumber.fromJson(x))),
    photo: json["photo"] == null ? "" : json["photo"],
  );

  factory ComeInPerson.empty() =>
      ComeInPerson(
          id: 0,
          phoneNumbers: [],
          fullName: "",
          photo: ""
      );


}

class PhoneNumber {
  PhoneNumber({
    required this.id,
    required this.phoneNumber,
  });

  int id;
  String phoneNumber;

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
    id: json["id"] == null ? 0 : json["id"],
    phoneNumber: json["phone_number"] == null ? "" : json["phone_number"],
  );

  factory PhoneNumber.empty() =>
      PhoneNumber(
        id: 0,
        phoneNumber: ""
      );

}

class Status {
  Status({
    required this.id,
    required this.title,
    required this.color,
  });

  int id;
  String title;
  String color;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
    color: json["color"] == null ? "" : json["color"],
  );

  factory Status.empty() =>
      Status(
        color: "",
        title: "",
        id: 0
      );
}

class Child {
  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.photo,
  });

  int id;
  String firstName;
  String lastName;
  String middleName;
  String photo;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["id"] == null ? 0 : json["id"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    photo: json["photo"] == null ? "" : json["photo"],
  );

  factory Child.empty() =>
      Child(
          photo: "",
          middleName: "",
          id: 0,
          firstName: "",
          lastName: ""
      );
}
