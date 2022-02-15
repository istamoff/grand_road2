
class LocalChildAddModel{
  final String first_name;
  final String last_name;
  final String middle_name;
  final int  child_group;
  final String address;
  final String birth_date;
  final String joined_date;
  final String gender_type;
  final bool is_active;

  LocalChildAddModel({required this.first_name, required this.last_name, required this.middle_name, required this.child_group, required this.address, required this.birth_date, required this.joined_date, required this.gender_type, required this.is_active});
  factory LocalChildAddModel.empty() =>
      LocalChildAddModel(
         address: "",
         birth_date: "",
        child_group: 0,
        first_name: "",
        gender_type: "",
        is_active: false,
        joined_date: "",
        last_name: "",
        middle_name: ""
      );
}