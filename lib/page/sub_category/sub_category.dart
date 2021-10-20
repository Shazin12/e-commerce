import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/page/sub_category/sub_cat_add.dart';
import 'package:web_test/page/sub_category/sub_cat_edit.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';
import 'package:web_test/widget/table.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({Key? key}) : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  TextEditingController searchValue = TextEditingController(text: '');

  bool isSearching = false;

  int select = 0;

  List value = [
    {"id": "no", "name": "All", "image": "/all/all.jpeg"}
  ];

  bool boolValue = false;
  var font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   // category data
    //   context.read<PHP_DB_Category>().data.isNotEmpty
    //       ? debugPrint('Data not empty')
    //       : context.read<PHP_DB_Category>().getData();
    //   // sub category
    //   context.read<PHP_DB_SubCategory>().data.isNotEmpty
    //       ? debugPrint('Data not empty in sub')
    //       : context.read<PHP_DB_SubCategory>().getData();
    //   // brand data
    //   context.read<PHP_DB_Brand>().data.isNotEmpty
    //       ? debugPrint('Data not empty in brand')
    //       : context.read<PHP_DB_Brand>().getData();
    //   // group data
    //   context.read<PHP_DB_Group>().data.isNotEmpty
    //       ? debugPrint('Data not empty in brand')
    //       : context.read<PHP_DB_Group>().getData();

    valueAdd();
    // });
    super.initState();
  }

  valueAdd() {
    try {
      setState(() {
        boolValue = false;
      });
      for (var i = 0; i < context.read<PHP_DB_Category>().data.length; i++) {
        setState(() {
          value.add({
            "id": context.read<PHP_DB_Category>().data[i].id,
            "name": context.read<PHP_DB_Category>().data[i].categoryName,
            "image": context.read<PHP_DB_Category>().data[i].image,
          });
        });
      }
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        setState(() {
          boolValue = true;
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // categoryLoader.getData();
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => SubCategoryAdd()));
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
          backgroundColor: Color.fromRGBO(189, 212, 231, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)))),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(83, 184, 187, 0.0),
        title: Text(
          'Sub Catogory',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                context.read<PHP_DB_SubCategory>().getData();
              },
              icon: Icon(Icons.refresh_outlined))
        ],
      ),
      body: Column(
        children: [
          category(),
          searchfield(),
          context.watch<PHP_DB_SubCategory>().dataload == true
              ? Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              //  : Container()
              : Expanded(
                  child: CustomTable(
                  updateOn: updateOn,
                  model: SubCategoryModel,
                  deleteOn: deleteOn,
                  error: context.watch<PHP_DB_SubCategory>().errorText,
                  data: isSearching == false
                      ? context.watch<PHP_DB_SubCategory>().data
                      : context.watch<PHP_DB_SubCategory>().searchdata,
                ))
        ],
      ),
    );
  }

  searchfield() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: searchValue,
          onChanged: (v) {
            setState(() {
              isSearching = v.isEmpty ? false : true;
            });
            context.read<PHP_DB_SubCategory>().searchValueChanger(v.toString());
          },
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }

  category() {
    try {
      return Container(
        //  color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: boolValue == false
            ? Center(
                child: CircularProgressIndicator(),
              )
            //: CustomTable(updateOn: updateOn, deleteOn: deleteOn, data: context.watch<PHP_DB_SubCategory>().data)
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          select = i;
                          isSearching = false;
                          searchValue = TextEditingController(text: null);
                          context
                              .read<PHP_DB_SubCategory>()
                              .searchValueChanger(searchValue.toString());
                        });
                        context
                            .read<PHP_DB_SubCategory>()
                            .splitData(value[i]['id']);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(189, 212, 231, 1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.5,
                                  color: select == i
                                      ? Colors.white
                                      : Colors.transparent)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                                child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(
                                      imageUrls + value[i]["image"]),
                                  radius: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(value[i]["name"].toString(), style: font),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                          )),
                    ),
                  );
                }),
      );
    } catch (e) {}
  }

  void updateOn(SubCategoryModel result) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => SubCategoryEdit(
              subcategoryname: result.subCategoryName.toString(),
              id: result.id.toString(),
              categoryId: result.categoryId.toString(),
              imagepath: result.image.toString(),
              isactive: result.isActive.toString(),
            )));
  }

  void deleteOn(SubCategoryModel e) {
    CoolAlert.show(
        barrierDismissible: true,
        context: context,
        type: CoolAlertType.info,
        text:
            'Are You Sure You Wanted To Delete " ${e.subCategoryName.toString()} "',
        //  confirmBtnText: 'Ok',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          context
              .read<PHP_DB_SubCategory>()
              .deleteCategory(
                  id: e.id.toString(),
                  imagepath: e.image.toString(),
                  context: context)
              .then((v) {
            isSearching = false;
            searchValue = TextEditingController(text: null);
            context
                .read<PHP_DB_SubCategory>()
                .searchValueChanger(searchValue.toString());
          });
        });
  }
}

/**
 * 
   
 */
