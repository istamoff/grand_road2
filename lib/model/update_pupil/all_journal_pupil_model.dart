// class AllPupilModel {
//   AllPupilModel({
//     required this.count,
//     required this.next,
//     required this.previous,
//     required this.results,
//   });
//
//   int count;
//   String next;
//   dynamic previous;
//   List<Result> results;
//
//   factory AllPupilModel.fromJson(Map<String, dynamic> json) => AllPupilModel(
//     count: json["count"] == null ? 0 : json["count"],
//     next: json["next"] == null ? "" : json["next"],
//     previous: json["previous"] == null ? "" : json["previous"],
//     results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
//   );
// }
//
// class Result {
//   Result({
//     required this.id,
//     required this.child,
//     required this.comeInTime,
//     required this.comeInPerson,
//     required this.temperature,
//     required this.nurse,
//     required this.comment,
//     required this.status,
//     required this.receivedTeacher,
//     required this.receivedTime,
//     required this.goOutPerson,
//     required this.goOutTime,
//     required this.sentTeacher,
//   });
//
//   int id;
//   Child child;
//   DateTime comeInTime;
//   ComeInPerson comeInPerson;
//   double temperature;
//   int nurse;
//   String comment;
//   Status status;
//   int receivedTeacher;
//   DateTime receivedTime;
//   dynamic goOutPerson;
//   dynamic goOutTime;
//   dynamic sentTeacher;
//
//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//     id: json["id"] == null ? 0 : json["id"],
//     child: json["child"] == null ? Child.empty() : Child.fromJson(json["child"]),
//     comeInTime: json["come_in_time"] == null ? DateTime(0) : DateTime.parse(json["come_in_time"]),
//     comeInPerson: json["come_in_person"] == null ? ComeInPerson.empty() : ComeInPerson.fromJson(json["come_in_person"]),
//     temperature: json["temperature"] == null ? 0 : json["temperature"].toDouble(),
//     nurse: json["nurse"] == null ? 0 : json["nurse"],
//     comment: json["comment"] == null ? null : json["comment"],
//     status: json["status"] == null ? null : Status.fromJson(json["status"]),
//     receivedTeacher: json["received_teacher"] == null ? null : json["received_teacher"],
//     receivedTime: json["received_time"] == null ? null : DateTime.parse(json["received_time"]),
//     goOutPerson: json["go_out_person"],
//     goOutTime: json["go_out_time"],
//     sentTeacher: json["sent_teacher"],
//   );
//
// }
//
// class Child {
//   Child({
//     required this.id,
//     required this.fullName,
//     required this.photo,
//     required this.childGroup,
//     required this.childClass,
//   });
//
//   int id;
//   String fullName;
//   String photo;
//   String childGroup;
//   String childClass;
//
//   factory Child.fromJson(Map<String, dynamic> json) => Child(
//     id: json["id"] == null ? null : json["id"],
//     fullName: json["full_name"] == null ? null : json["full_name"],
//     photo: json["photo"] == null ? null : json["photo"],
//     childGroup: json["child_group"] == null ? null : json["child_group"],
//     childClass: json["child_class"] == null ? null : json["child_class"],
//   );
//
//   factory Child.empty() =>
//       Child(
//          id: 0,
//          photo: "",
//          fullName: "",
//          childClass: "",
//          childGroup: ""
//       );
// }
//
// class ComeInPerson {
//   ComeInPerson({
//     required this.photo,
//   });
//
//   String photo;
//
//   factory ComeInPerson.fromJson(Map<String, dynamic> json) => ComeInPerson(
//     photo: json["photo"],
//   );
//
//   factory ComeInPerson.empty() =>
//       ComeInPerson(
//          photo: ""
//       );
//
// }
//
// class Status {
//   Status({
//     required this.id,
//     required this.title,
//     required this.color,
//   });
//
//   int id;
//   String title;
//   String color;
//
//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//     id: json["id"] == null ? null : json["id"],
//     title: json["title"] == null ? null : json["title"],
//     color: json["color"] == null ? null : json["color"],
//   );
//
//   factory Status.empty() =>
//       Status(
//           id: 0,
//         title: "",
//         color: ""
//       );
//
// }
