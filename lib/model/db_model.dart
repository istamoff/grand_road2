class DbModel {
  DbModel({
     required this.childId,
     required this.photoUrl,
     required this.relation
  });

  int childId;
  String photoUrl;
  String relation;


  factory DbModel.empty() =>
      DbModel(childId: 0, photoUrl: "", relation: "");

  Map<String, dynamic> toJson() => {
    "url" : photoUrl,
    "relation": relation,
    "childId": childId
  };

}