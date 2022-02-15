class TeacherReceiverModel {
  TeacherReceiverModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory TeacherReceiverModel.fromJson(Map<String, dynamic> json) => TeacherReceiverModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory TeacherReceiverModel.empty() =>
      TeacherReceiverModel(
        count: 0,
        next: "",
        previous: "",
        results: []
      );
}

class Result {
  Result({
    required this.id,
    required this.receivedTeacher,
    required this.receivedTime,
    required this.child,
  });

  int id;
  ReceivedTeacher receivedTeacher;
  DateTime receivedTime;
  Child child;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    receivedTeacher: json["received_teacher"] == null ? ReceivedTeacher.empty(): ReceivedTeacher.fromJson(json["received_teacher"]),
    receivedTime: json["received_time"] == null ? DateTime(0) : DateTime.parse(json["received_time"]),
    child: json["child"] == null ? Child.empty() : Child.fromJson(json["child"])
  );


}

class ReceivedTeacher {
  ReceivedTeacher({
    required this.id,
    required this.photo,
    required this.firstName,
    required this.lastName,
    required this.middleName,
  });

  int id;
  String photo;
  String firstName;
  String lastName;
  String middleName;

  factory ReceivedTeacher.fromJson(Map<String, dynamic> json) => ReceivedTeacher(
    id: json["id"] == null ? 0 : json["id"],
    photo: json["photo"] == null ? "" : json["photo"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
  );

  factory ReceivedTeacher.empty() =>
      ReceivedTeacher(
          firstName: "",
          id: 0,
          lastName: "",
          middleName: "",
          photo: ""
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
