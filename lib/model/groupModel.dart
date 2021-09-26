// To parse this JSON data, do
//
//     final GroupModel = GroupModelFromJson(jsonString);

import 'dart:convert';

GroupModel groupModelFromJson(String str) =>
    GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
  GroupModel({
    required this.id,
    required this.groupName,
    required this.createdAt,
  });

  String id;
  String groupName;
  String createdAt;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json["id"],
        groupName: json["group_name"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "created_at": createdAt,
      };
}
