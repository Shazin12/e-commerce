// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

BrandModel brandModelFromJson(String str) =>
    BrandModel.fromJson(json.decode(str));

String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
  BrandModel({
    required this.id,
    required this.brandName,
    required this.brandDes,
    required this.createdAt,
  });

  String id;
  String brandName;
  String brandDes;
  String createdAt;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json["id"],
        brandName: json["brand_name"],
        brandDes: json["brand_des"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        " brand_name": brandName,
        " brand_des": brandDes,
        " created_at": createdAt,
      };
}
