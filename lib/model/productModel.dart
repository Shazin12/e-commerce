// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    ProductModel({
        required this.id,
        required this.mainImage,
        required this.image1,
        required this.image2,
        required this.image3,
        required this.image4,
        required this.image5,
        required this.isActive,
        required this.returnAvailable,
        required this.categoryId,
        required this.subCategoryId,
        required this.brandId,
        required this.groupId,
        required this.mrp,
        required this.stock,
        required this.selling,
        required this.productCode,
        required this.deliveryCost,
        required this.createdAt,
    });

    String id;
    String mainImage;
    String image1;
    String image2;
    String image3;
    String image4;
    String image5;
    String isActive;
    String returnAvailable;
    String categoryId;
    String subCategoryId;
    String brandId;
    String groupId;
    String mrp;
    String stock;
    String selling;
    String productCode;
    String deliveryCost;
    DateTime createdAt;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        mainImage: json["main_image"],
        image1: json["image_1"],
        image2: json["image_2"],
        image3: json["image_3"],
        image4: json["image_4"],
        image5: json["image_5"],
        isActive: json["is_active"],
        returnAvailable: json["return_available"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        brandId: json["brand_id"],
        groupId: json["group_id"],
        mrp: json["mrp"],
        stock: json["stock"],
        selling: json["selling"],
        productCode: json["product_code"],
        deliveryCost: json["delivery_cost"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "main_image": mainImage,
        "image_1": image1,
        "image_2": image2,
        "image_3": image3,
        "image_4": image4,
        "image_5": image5,
        "is_active": isActive,
        "return_available": returnAvailable,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "brand_id": brandId,
        "group_id": groupId,
        "mrp": mrp,
        "stock": stock,
        "selling": selling,
        "product_code": productCode,
        "delivery_cost": deliveryCost,
        "created_at": createdAt.toIso8601String(),
    };
}
