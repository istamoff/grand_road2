class LoginModel {
  LoginModel({
    required this.refresh,
    required  this.access,
   required  this.userData,
  });

  String refresh;
  String access;
  UserData userData;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    refresh: json["refresh"] == null ? "" : json["refresh"],
    access: json["access"] == null ? "" : json["access"],
    userData: json["user_data"] == null ? UserData.empty() : UserData.fromJson(json["user_data"]),
  );
}

class UserData {
  UserData({
   required  this.id,
   required  this.firstName,
   required  this.lastName,
   required  this.fullName,
   required  this.username,
   required  this.dateJoined,
   required  this.lastLogin,
   required  this.isActive,
   required  this.role,
   required  this.isSuperuser,
   required  this.language,
   required this.theme,
   required this.permission,
   required this.roleName,
   required this.fullRoleName
  });

  int id;
  String firstName;
  String lastName;
  String fullName;
  String username;
  DateTime dateJoined;
  DateTime lastLogin;
  bool isActive;
  String theme;
  List<String> role;
  bool isSuperuser;
  String language;
  List<String> permission;
  String roleName;
  FullRoleName fullRoleName;

  factory UserData.empty() =>
      UserData(id: 0, firstName: "", lastName: "",
          fullName: "",  username: "", dateJoined: DateTime(0),
          lastLogin: DateTime(0), isActive: false, role: [], language: "", isSuperuser: false,
          theme : "", permission: [], roleName: "",
          fullRoleName: FullRoleName.empty()
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"] == null ? 0 : json["id"],
    firstName: json["first_name"] == null ? "" : json["first_name"],
    lastName: json["last_name"] == null ? "" : json["last_name"],
    fullName: json["full_name"] == null ? "" : json["full_name"],
    username: json["username"] == null ? "" : json["username"],
    dateJoined: json["date_joined"] == null ? DateTime(0) : DateTime.parse(json["date_joined"]),
    lastLogin: json["last_login"] == null ? DateTime(0) : DateTime.parse(json["last_login"]),
    isActive: json["is_active"] == null ? false : json["is_active"],
    theme: json["theme"] == null ? "" : json["theme"],
    role: json["role"] == null ? [] : List<String>.from(json["role"].map((x) => x)),
    isSuperuser: json["is_superuser"] == null ? false : json["is_superuser"],
    language: json["language"] == null ? "" : json["language"],
    permission: json["permission"] == null ? [] : List<String>.from(json["permission"].map((x) => x)),
    roleName: json["role_name"] == null ? "" : json["role_name"],
    fullRoleName: json["full_role_name"] == null ? FullRoleName.empty() : FullRoleName.fromJson(json["full_role_name"]),
    );

}

class FullRoleName {
  FullRoleName({
    required this.ru,
    required this.uz,
  });

  String ru;
  String uz;

  factory FullRoleName.fromJson(Map<String, dynamic> json) => FullRoleName(
    ru: json["ru"] == null ? "" : json["ru"],
    uz: json["uz"] == null ? "" : json["uz"],
  );

  factory FullRoleName.empty() =>
      FullRoleName(
        uz: "",
        ru: ""
      );

}



