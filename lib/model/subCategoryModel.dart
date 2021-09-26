// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
    SubCategoryModel({
        this.id,
        this.categoryId,
        this.subCategoryName,
        this.image,
        this.isActive,
        this.createdAt,
    });

    String? id;
    String? categoryId;
    String? subCategoryName;
    String? image;
    String? isActive;
    String? createdAt;

    factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        id: json["id"],
        categoryId: json["category_id"],
        subCategoryName: json["sub_category_name"],
        image: json["image"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "sub_category_name": subCategoryName,
        "image": image,
        "is_active": isActive,
        "created_at": createdAt,
    };
}
