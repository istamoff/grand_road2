import 'package:unikids_uz/model/teacher_receiver_model.dart';

class ChildInOutModel {
  ChildInOutModel({
    required  this.count,
    required  this.next,
    required  this.previous,
    required  this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory ChildInOutModel.fromJson(Map<String, dynamic> json) => ChildInOutModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory ChildInOutModel.empty() =>
      ChildInOutModel(results: [], previous: "", next: "", count: 0);
}

class Result {
  Result({
    required  this.id,
    required  this.comeInPerson,
    required  this.comeInTime,
    required  this.nurse,
    required  this.temperature,
    required  this.receivedTeacher,
    required  this.receivedTime,
    required  this.goOutPerson,
    required  this.goOutTime,
    required  this.status,
    required  this.comment,
    required  this.receivePhoto,
    required  this.sendPhoto,
  });

  int id;
  Person comeInPerson;
  DateTime comeInTime;
  Nurse nurse;
  double temperature;
  Nurse receivedTeacher;
  DateTime receivedTime;
  Person goOutPerson;
  DateTime goOutTime;
  Status status;
  String comment;
  String receivePhoto;
  String sendPhoto;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    comeInPerson: json["come_in_person"] == null ? Person.empty() : Person.fromJson(json["come_in_person"]),
    comeInTime: json["come_in_time"] == null ? DateTime(0) : DateTime.parse(json["come_in_time"]),
    nurse: json["nurse"] == null ? Nurse.empty() : Nurse.fromJson(json["nurse"]),
    temperature: json["temperature"] == null ? 0 : json["temperature"].toDouble(),
    receivedTeacher: json["received_teacher"] == null ? Nurse.empty() : Nurse.fromJson(json["received_teacher"]),
    receivedTime: json["received_time"] == null ? DateTime(0) : DateTime.parse(json["received_time"]),
    goOutPerson: json["go_out_person"] == null ? Person.empty() : Person.fromJson(json["go_out_person"]),
    goOutTime: json["go_out_time"] == null ? DateTime(0) : DateTime.parse(json["go_out_time"]),
    status: json["status"] == null ? Status.empty() : Status.fromJson(json["status"]),
    comment: json["comment"] == null ? "" : json["comment"],
    receivePhoto: json["receive_photo"] == null ? "" : json["receive_photo"],
    sendPhoto: json["send_photo"] == null ? "" : json["send_photo"],
  );

  factory Result.empty() =>
      Result(id: 0, goOutTime: DateTime(0), goOutPerson: Person.empty(),
          comeInPerson: Person.empty(), comeInTime: DateTime(0),
          comment: "", nurse: Nurse.empty(), receivedTeacher: Nurse.empty(), receivedTime: DateTime(0),
          receivePhoto: "", sendPhoto: "", status: Status.empty(), temperature: 0);
}

class Person {
  Person({
    required  this.id,
    required  this.fullName,
    required  this.phoneNumbers,
    required  this.photo,
  });

  int id;
  String fullName;
  List<PhoneNumber> phoneNumbers;
  String photo;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json["id"] == null ? 0 : json["id"],
    fullName: json["full_name"] == null ? "" : json["full_name"],
    phoneNumbers: json["phone_numbers"] == null ? [] : List<PhoneNumber>.from(json["phone_numbers"].map((x) => PhoneNumber.fromJson(x))),
    photo: json["photo"] == null ? "" : json["photo"],
  );

  factory Person.empty() =>
      Person(id: 0, photo: "", phoneNumbers: [], fullName: "");
}

class PhoneNumber {
  PhoneNumber({
    required  this.id,
    required  this.phoneNumber,
  });

  int id;
  String phoneNumber;

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
    id: json["id"] == null ? 0 : json["id"],
    phoneNumber: json["phone_number"] == null ? "" : json["phone_number"],
  );

  factory PhoneNumber.empty() =>
      PhoneNumber(id: 0, phoneNumber: "");
}

class Nurse {
  Nurse({
    required  this.id,
    required  this.photo,
    required  this.firstName,
    required  this.lastName,
    required  this.middleName,
  });

  int id;
  String photo;
  String firstName;
  String lastName;
  String middleName;

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
    id: json["id"] == null ? 0 : json["id"],
    photo: json["photo"] == null ? "" : json["photo"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
  );

  factory Nurse.empty() =>
      Nurse(id: 0, middleName: "", lastName: "", firstName: "", photo: "");
}

class Status {
  Status({
    required  this.id,
    required  this.title,
    required  this.color,
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
      Status(id: 0, title: "", color: "");
}
