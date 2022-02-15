class TeacherGoOutModel {
  TeacherGoOutModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory TeacherGoOutModel.fromJson(Map<String, dynamic> json) => TeacherGoOutModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    required this.id,
    required this.child,
    required this.goOutPerson,
    required this.goOutTime,
  });

  int id;
  Child child;
  GoOutPerson goOutPerson;
  DateTime goOutTime;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    child: json["child"] == null ? Child.empty() : Child.fromJson(json["child"]),
    goOutPerson: json["go_out_person"] == null ? GoOutPerson.empty() : GoOutPerson.fromJson(json["go_out_person"]),
    goOutTime: json["go_out_time"] == null ? DateTime(0) : DateTime.parse(json["go_out_time"]),
  );

  factory Result.empty() => Result(
     id: 0,
    child: Child.empty(),
    goOutPerson: GoOutPerson.empty(),
    goOutTime: DateTime(0)
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
  
  factory Child.empty() => Child(
    id: 0,
    middleName: "",
    lastName: "",
    firstName: "",
    photo: ""
  );


}

class GoOutPerson {
  GoOutPerson({
    required this.id,
    required this.fullName,
    required this.phoneNumbers,
    required this.photo,
  });

  int id;
  String fullName;
  List<PhoneNumber> phoneNumbers;
  String photo;

  factory GoOutPerson.fromJson(Map<String, dynamic> json) => GoOutPerson(
    id: json["id"] == null ? null : json["id"],
    fullName: json["full_name"] == null ? null : json["full_name"],
    phoneNumbers: json["phone_numbers"] == null ? [] : List<PhoneNumber>.from(json["phone_numbers"].map((x) => PhoneNumber.fromJson(x))),
    photo: json["photo"] == null ? "" : json["photo"],
  );

  factory GoOutPerson.empty() => GoOutPerson(
    id: 0,
    photo: "",
    fullName: "",
    phoneNumbers: []
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
    id: json["id"] == null ? null : json["id"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
  );

  factory PhoneNumber.empty() => PhoneNumber(
    id: 0,
    phoneNumber: ""
  );
 
}


