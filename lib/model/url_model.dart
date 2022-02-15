class UrlModel {
  UrlModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Result> results;

  factory UrlModel.fromJson(Map<String, dynamic> json) => UrlModel(
    count: json["count"] == null ? 0 : json["count"],
    next: json["next"] == null ? "" : json["next"],
    previous: json["previous"] == null ? "" : json["next"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  factory UrlModel.empty() =>
      UrlModel(count: 0, next: "", previous: "", results: []);

}

class Result {
  Result({
    required this.title,
    required this.url,
  });

  String title;
  String url;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    title: json["title"] == null ? "" : json["title"],
    url: json["url"] == null ? "" : json["url"],
  );

  factory Result.empty() =>
      Result(title: "", url: "");

}
