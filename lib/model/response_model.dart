class InfoModel {
  InfoModel({
   required  this.isSuccess,
   required  this.result,
  });

  bool isSuccess;
  List<Result> result;

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
    isSuccess: json["is_success"] == null ? false : json["is_success"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );


  factory InfoModel.empty() =>
      InfoModel(isSuccess: false, result: []);

}

class Result {
  Result({
   required  this.id,
   required  this.firstName,
   required  this.lastName,
   required  this.middleName,
   required  this.birthDate,
   required  this.photo,
   required  this.humans,
   required  this.childGroup,
  });

  int id;
  String firstName;
  String lastName;
  String middleName;
  DateTime birthDate;
  String photo;
  List<Human> humans;
  ChildGroup childGroup;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"] == null ? 0 : json["id"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    birthDate: json["birth_date"] == null ? DateTime(0) : DateTime.parse(json["birth_date"]),
    photo: json["photo"] == null ? "" : json["photo"],
    humans: json["humans"] == null ? [] : List<Human>.from(json["humans"].map((x) => Human.fromJson(x))),
    childGroup: json["child_group"] == null ? ChildGroup.empty() : ChildGroup.fromJson(json["child_group"]),
  );

  factory Result.empty() =>
      Result(id: 0, firstName: "", lastName: "", middleName: "", photo: "", birthDate: DateTime(0), childGroup: ChildGroup.empty(),  humans: []);
}

class ChildGroup {
  ChildGroup({
   required  this.id,
   required  this.title,
   required  this.className,
  });

  int id;
  String title;
  String className;

  factory ChildGroup.fromJson(Map<String, dynamic> json) => ChildGroup(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    className: json["class_name"] == null ? null : json["class_name"],
  );

  factory ChildGroup.empty() =>
      ChildGroup(title: "", id: 0, className: "");
}

class Human {
  Human({
   required  this.id,
   required  this.firstName,
   required  this.lastName,
   required  this.middleName,
   required  this.photo,
   required  this.phoneNumber,
   required  this.relativityType,
  });

  int id;
  String firstName;
  String lastName;
  String middleName;
  String photo;
  String phoneNumber;
  RelativityType relativityType;

  factory Human.fromJson(Map<String, dynamic> json) => Human(
    id: json["id"] == null ? 0 : json["id"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    photo: json["photo"] == null ? "" : json["photo"],
    phoneNumber: json["phone_number"] == null ? "" : json["phone_number"],
    relativityType: json["relativity_type"] == null ? RelativityType.empty() : RelativityType.fromJson(json["relativity_type"]),
  );

  factory Human.empty() =>
      Human(photo: "", middleName: "", lastName: "", firstName: "", id: 0, relativityType: RelativityType.empty(), phoneNumber: "");
}

class RelativityType {
  RelativityType({
   required  this.id,
   required  this.title,
  });

  int id;
  String title;

  factory RelativityType.fromJson(Map<String, dynamic> json) => RelativityType(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
  );


  factory RelativityType.empty() =>
      RelativityType(id: 0, title: "");
}
