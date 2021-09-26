

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.id,
    this.categoryName,
    this.image,
    this.isActive,
    this.createdAt,
  });

  String? id;
  String? categoryName;
  String? image;
  String? isActive;
  String? createdAt;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        categoryName: json["category_name"],
        image: json["image"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "image": image,
        "is_active": isActive,
        "created_at": createdAt,
      };
}
