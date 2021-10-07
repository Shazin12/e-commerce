import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/page/product/provider/cate_provider.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_Group.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/widget/dropDown.dart';

import '../../../url.dart';

class Drop extends StatefulWidget {
  const Drop({Key? key}) : super(key: key);

  @override
  _DropState createState() => _DropState();
}

class _DropState extends State<Drop> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CateProvider>(builder: (_, v, c) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: CusDropDown(
                  stockWidth: 2,
                  height: 40,
                  width: 220,
                  items: categoryItem(v),
                  onChange: (v) {},
                  selectName: v.selectCategory.categoryName.toString(),
                ),
              ),
              Container(
                child: CusDropDown(
                  stockWidth: 2,
                  height: 40,
                  width: 220,
                  items: subcategoryItem(v),
                  onChange: (v) {},
                  selectName: v.selectSubCategory.subCategoryName.toString(),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 30,
          ),
          // brand and group  ↓ ↓ ↓
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: CusDropDown(
                  stockWidth: 2,
                  height: 40,
                  width: 220,
                  items: brandItem(v),
                  onChange: (v) {},
                  selectName: v.brand.brandName.toString(),
                ),
              ),
              Container(
                child: CusDropDown(
                  stockWidth: 2,
                  height: 40,
                  width: 220,
                  items: groupItem(v),
                  onChange: (v) {},
                  selectName: v.group.groupName.toString(),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  categoryItem(CateProvider c) {
    return context.watch<PHP_DB_Category>().data.map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          c.changeCategory(CategoryModel(
              categoryName: value.categoryName,
              id: value.id,
              image: value.image,
              isActive: value.isActive,
              createdAt: value.createdAt));
          c.changeSubCategory(SubCategoryModel(
              subCategoryName: 'Select Sub Category',
              id: 'id',
              image: 'image',
              isActive: ' isActive',
              categoryId: 'categoryId',
              createdAt: 'createdAt'));
        },
        value: value.categoryName,
        child: selectedText(c.selectCategory.id.toString(),
            value.categoryName.toString(), value.id.toString()),
      );
    }).toList();
    // ignore: dead_code
  }

  subcategoryItem(CateProvider c) {
    return context
        .watch<PHP_DB_SubCategory>()
        .data
        .where((element) => element.categoryId == c.selectCategory.id)
        .map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          c.changeSubCategory(SubCategoryModel(
              subCategoryName: value.subCategoryName,
              id: value.id,
              image: value.image,
              isActive: value.isActive,
              categoryId: value.categoryId,
              createdAt: value.createdAt));
        },
        value: value.subCategoryName,
        child: selectedText(c.selectSubCategory.id.toString(),
            value.subCategoryName.toString(), value.id.toString()),
      );
    }).toList();
    // ignore: dead_code
  }

  brandItem(CateProvider c) {
    return context.watch<PHP_DB_Brand>().data.map((value) {
      return DropdownMenuItem<String>(
          onTap: () {
            c.changeBrand(BrandModel(
              brandName: value.brandName,
              brandDes: value.brandDes,
              id: value.id,
              createdAt: value.createdAt,
            ));
          },
          value: value.brandName,
          child: selectedText(c.brand.id, value.brandName, value.id));
    }).toList();
    // ignore: dead_code
  }

  groupItem(CateProvider c) {
    return context.watch<PHP_DB_Group>().data.map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          c.changeGroup(GroupModel(
            groupName: value.groupName,
            id: value.id,
            createdAt: value.createdAt,
          ));
        },
        value: value.groupName,
        child: selectedText(c.group.id, value.groupName, value.id),
      );
    }).toList();
  }

  selectedText(String id, String name, String id2) {
    return Row(
      children: [
        Container(
          width: id == id2 ? 10 : 0,
          height: id == id2 ? 10 : 0,
          decoration: BoxDecoration(color: bkColorO8, shape: BoxShape.circle),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
            width: 192,
            child: Text(
              name.toString(),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}
