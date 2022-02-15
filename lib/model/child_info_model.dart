class ChildInfoModel {
  ChildInfoModel({
    required this.id,
    required this.photo,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.birthDate,
    required this.genderType,
    required this.address,
    required this.accountNumber,
    required this.childGroup,
    required this.childClass,
    required this.isActive,
  });

  int id;
  String photo;
  String firstName;
  String lastName;
  String middleName;
  DateTime birthDate;
  String genderType;
  String address;
  AccountNumber accountNumber;
  Child childGroup;
  Child childClass;
  bool isActive;

  factory ChildInfoModel.fromJson(Map<String, dynamic> json) => ChildInfoModel(
    id: json["id"] == null ? 0 : json["id"],
    photo: json["photo"] == null ? "" : json["photo"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    middleName: json["middle_name"] == null ? "" : json["middle_name"],
    birthDate: json["birth_date"] == null ? DateTime(0) : DateTime.parse(json["birth_date"]),
    genderType: json["gender_type"] == null ? "" : json["gender_type"],
    address: json["address"] == null ? "" : json["address"],
    accountNumber: json["account_number"] == null ? AccountNumber.empty() : AccountNumber.fromJson(json["account_number"]),
    childGroup: json["child_group"] == null ? Child.empty() : Child.fromJson(json["child_group"]),
    childClass: json["child_class"] == null ? Child.empty() : Child.fromJson(json["child_class"]),
    isActive: json["is_active"] == null ? false : json["is_active"],
  );

  factory ChildInfoModel.empty() =>
      ChildInfoModel(id: 0, address: "", photo: "", firstName: "", lastName: "",
          middleName: "", childClass: Child.empty(), childGroup: Child.empty(), genderType: "", birthDate: DateTime(0), accountNumber: AccountNumber.empty(), isActive: false);
}

class AccountNumber {
  AccountNumber({
    required this.id,
    required this.number,
    required this.balance,
  });

  int id;
  int number;
  int balance;

  factory AccountNumber.fromJson(Map<String, dynamic> json) => AccountNumber(
    id: json["id"] == null ? 0 : json["id"],
    number: json["number"] == null ? 0 : json["number"],
    balance: json["balance"] == null ? 0 : json["balance"],
  );

  factory AccountNumber.empty() =>
      AccountNumber(id: 0, number: 0, balance: 0);

}

class Child {
  Child({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? "" : json["title"],
  );

  factory Child.empty() =>
      Child(id: 0, title: "");
}
