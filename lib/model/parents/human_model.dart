class HumansModel {
  HumansModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.birthDate,
    required this.genderType,
    required this.relativityType,
    required this.photo,
    required this.contacts,
    required this.relativityId
  });

  int id;
  String firstName;
  String lastName;
  String middleName;
  DateTime birthDate;
  String genderType;
  String relativityType;
  String photo;
  int relativityId;
  List<String> contacts;

  factory HumansModel.fromJson(Map<String, dynamic> json) => HumansModel(
    id: json["id"] == null ? 0 : json["id"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    birthDate: json["birth_date"] == null ? DateTime(0) : json["birth_date"],
    genderType: json["gender_type"] == null ? "" : json["gender_type"],
    relativityType: json["relativity_type"] == null ? "" : json["relativity_type"],
    relativityId: json["relativity_id"] == null ? 0 : json["relativity_id"],
    photo: json["photo"] == null ? "" : json["photo"],
    contacts: json["contacts"] == null ? [] : List<String>.from(json["contacts"].map((x) => x)),
  );
  
}
