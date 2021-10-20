import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomTable extends StatelessWidget {
  Function updateOn;
  Function deleteOn;
  final List data;
  var model;
  var error;
  bool? trailIconNeed = false;
  Function? trailIconFun;

  CustomTable(
      {Key? key,
      required this.updateOn,
      required this.deleteOn,
      required this.data,
      required this.model,
      this.trailIconNeed = false,
      this.trailIconFun,
      required this.error})
      : super(key: key);
  TextStyle style = GoogleFonts.getFont('Josefin Sans', fontSize: 17);
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: error != null
          ? Center(
              child: Text(
                error,
                style: font,
              ),
            )
          : data.isEmpty
              ? Center(
                  child: Text(
                    'No Data',
                    style: font,
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (c, i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                      // ignore: sized_box_for_whitespace
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 50,
                        child: Card(
                          elevation: 5,
                          color: Color.fromRGBO(189, 212, 231, 1),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  // width: MediaQuery.of(context).size.width * 0.5,
                                  child: ListTile(
                                    leading: model == BrandModel ||
                                            model == GroupModel
                                        ? Container(
                                            width: 1,
                                            height: 1,
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  model == ProductModel
                                                      ? imageUrls +
                                                          data[i]
                                                              .mainImage
                                                              .toString()
                                                      : imageUrls +
                                                          data[i]
                                                              .image
                                                              .toString()),
                                            ),
                                          ),
                                    title: Text(
                                      title(i),
                                      overflow: TextOverflow.ellipsis,
                                      style: font,
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: subtitle(i, context),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: trail(data[i]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String title(i) {
    if (model == CategoryModel) {
      return data[i].categoryName.toString();
    } else if (model == BrandModel) {
      return data[i].brandName.toString();
    } else if (model == GroupModel) {
      return data[i].groupName.toString();
    } else if (model == ProductModel) {
      return data[i].productName.toString();
    } else {
      return data[i].subCategoryName.toString();
    }
  }

  Widget subtitle(i, BuildContext context) {
    if (model == BrandModel) {
      return Text(
        data[i].brandDes.toString(),
        overflow: TextOverflow.ellipsis,
        style: font,
      );
    } else if (model == GroupModel) {
      return Text('');
    } else if (model == ProductModel) {
      List<CategoryModel> category = context
          .read<PHP_DB_Category>()
          .data
          .where((element) => element.id == data[i].categoryId)
          .toList();
      List<SubCategoryModel> subcategory = context
          .read<PHP_DB_SubCategory>()
          .data
          .where((element) => element.id == data[i].subCategoryId)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.isEmpty
                ? "No Category"
                : "Category: ${category[0].categoryName}",
            overflow: TextOverflow.ellipsis,
            style: font,
          ),
          Text(
            subcategory.isEmpty
                ? "No Sub Category"
                : "Sub Category: ${subcategory[0].subCategoryName}",
            overflow: TextOverflow.ellipsis,
            style: font,
          ),
          Text(
            'Is Active ${data[i].isActive.toString() == "0" ? 'Yes' : "No"}',
            overflow: TextOverflow.ellipsis,
            style: font,
          ),
        ],
      );
    } else {
      return Text(
        'Is Active ${data[i].isActive.toString() == "0" ? 'Yes' : "No"}',
        overflow: TextOverflow.ellipsis,
        style: font,
      );
    }
  }

  Widget trail(i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        update(i),
        delete(i),
        trailIconNeed == false ? Container() : trailIcon(i)
      ],
    );
  }

  // ignore: type_annotate_public_apis
  Widget update(i) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(189, 212, 231, 1),
        ),
        onPressed: () => updateOn(i),
        child: Text(
          'Update',
          style: font,
        ));
  }

  Widget trailIcon(i) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(189, 212, 231, 1),
        ),
        onPressed: () => trailIconFun!(i),
        child: Icon(Icons.visibility_outlined));
  }

  // ignore: type_annotate_public_apis
  Widget delete(i) {
    // ProductModel d = data[i];
    // print(d.similar.m);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(189, 212, 231, 1),
        ),
        onPressed: () => deleteOn(i),
        child: Text(
          'Delete',
          style: font,
        ));
  }
}
