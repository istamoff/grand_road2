class ErrorImageValidModel {
  ErrorImageValidModel({
    required this.message,
  });

  Message message;

  factory ErrorImageValidModel.fromJson(Map<String, dynamic> json) => ErrorImageValidModel(
    message: json["message"] == null ? Message.empty() : Message.fromJson(json["message"]),
  );

  factory ErrorImageValidModel.empty() =>
      ErrorImageValidModel(message: Message.empty());
}

class Message {
  Message({
    required this.ru,
    required this.uz,
  });

  String ru;
  String uz;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    ru: json["ru"] == null ? null : json["ru"],
    uz: json["uz"] == null ? null : json["uz"],
  );

  factory Message.empty() =>
      Message(uz: "", ru: "");
}
