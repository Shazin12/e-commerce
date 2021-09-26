import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/url.dart';

// ignore: must_be_immutable
class CustomTable extends StatelessWidget {
  Function updateOn;
  Function deleteOn;
  final List data;
  var model;
  var error;

  CustomTable(
      {Key? key,
      required this.updateOn,
      required this.deleteOn,
      required this.data,
      required this.model,
      required this.error})
      : super(key: key);
  TextStyle style = GoogleFonts.getFont('Josefin Sans', fontSize: 17);
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison

    return error != null
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
                                                imageUrls +
                                                    data[i].image.toString()),
                                          ),
                                        ),
                                  title: Text(
                                    title(i),
                                    overflow: TextOverflow.ellipsis,
                                    style: font,
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      subtitle(i),
                                      overflow: TextOverflow.ellipsis,
                                      style: font,
                                    ),
                                  ),
                                  //   trailing: trail(i),
                                ),
                              ),
                              SizedBox(
                                width: 200,
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
              );
  }

  String title(i) {
    if (model == CategoryModel) {
      return data[i].categoryName.toString();
    } else if (model == BrandModel) {
      return data[i].brandName.toString();
    } else if (model == GroupModel) {
      return data[i].groupName.toString();
    } else {
      return data[i].subCategoryName.toString();
    }
  }

  String subtitle(i) {
    if (model == BrandModel) {
      return data[i].brandDes.toString();
    } else if (model == GroupModel) {
      return '';
    } else {
      return 'Is Active ${data[i].isActive.toString() == "0" ? 'Yes' : "No"}';
    }
  }

  Widget trail(i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [update(i), delete(i)],
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

  // ignore: type_annotate_public_apis
  Widget delete(i) {
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
