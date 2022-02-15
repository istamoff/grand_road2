class PictureErrorModel {
  PictureErrorModel({
    required this.message,
  });

  Message message;

  factory PictureErrorModel.fromJson(Map<String, dynamic> json) => PictureErrorModel(
    message: json["message"] == null ? Message.empty() : Message.fromJson(json["message"]),
  );

  factory PictureErrorModel.empty() =>
      PictureErrorModel(
         message: Message.empty()
      );

}

class Message {
  Message({
    required this.ru,
    required this.uz,
  });

  String ru;
  String uz;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    ru: json["ru"] == null ? "" : json["ru"],
    uz: json["uz"] == null ? "" : json["uz"],
  );


  factory Message.empty() =>
      Message(
        ru: "",
        uz: ""
      );

}
