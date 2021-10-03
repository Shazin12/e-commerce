import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/model/subCategoryModel.dart';

class CateProvider with ChangeNotifier {
  CategoryModel selectCategory = CategoryModel(
      categoryName: 'Select Category',
      id: 'id',
      isActive: 'isActive',
      image: 'image',
      createdAt: 'createdAt');

  SubCategoryModel selectSubCategory = SubCategoryModel(
      subCategoryName: 'Select Sub Category',
      id: 'id',
      image: 'image',
      isActive: ' isActive',
      categoryId: 'categoryId',
      createdAt: 'createdAt');

  BrandModel brand = BrandModel(
      brandName: 'Select Brand',
      id: 'id',
      brandDes: 'brandDes',
      createdAt: 'createdAt');

  GroupModel group = GroupModel(
    groupName: 'Select Group',
    id: 'id',
    createdAt: 'createdAt',
  );

  changeCategory(CategoryModel v) {
    selectCategory = v;
    notifyListeners();
  }

  changeSubCategory(SubCategoryModel v) {
    selectSubCategory = v;
    notifyListeners();
  }

  changeBrand(BrandModel v) {
    brand = v;
    notifyListeners();
  }

  changeGroup(GroupModel v) {
    group = v;
    notifyListeners();
  }
}
