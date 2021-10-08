class Similar {
  String? id;
  Similar({this.id});
  factory Similar.fromJson(Map<String, dynamic> json) => Similar(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}