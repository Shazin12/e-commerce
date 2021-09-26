import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/widget/dropDown.dart';
import 'package:web_test/widget/loader.dart';

// ignore: must_be_immutable
class SubCategoryAdd extends StatefulWidget {
  SubCategoryAdd({Key? key}) : super(key: key);

  @override
  _SubCategoryAddState createState() => _SubCategoryAddState();
}

class _SubCategoryAddState extends State<SubCategoryAdd> {
  TextEditingController _controller = TextEditingController();

  var img;
  var showimg;
  bool imgLoad = false;

  var pickedImage;
  var errortext;

  bool isSwitched = false;

  bool? isloading;

  CategoryModel selectCategory = CategoryModel(
      categoryName: 'Select Category',
      id: 'id',
      isActive: 'isActive',
      image: 'image',
      createdAt: 'createdAt');

  @override
  Widget build(BuildContext context) {
    // this for call functions
    // ignore: unused_local_variable
    var categoryLoader = context.read<PHP_DB_SubCategory>();
    // this for get variable data
    // ignore: unused_local_variable
    var categoryLoaderwatch = context.watch<PHP_DB_SubCategory>();

    return Material(
      child: Stack(
        children: [
          Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        color: Colors.yellow,
                        child: Center(
                            child: img != null
                                ? Image.memory(
                                    showimg,
                                    height: 200,
                                    width: 200,
                                  )
                                : Text(
                                    'image',
                                    style: TextStyle(fontSize: 20),
                                  )),
                      ),
                      // ignore: deprecated_member_use
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(189, 212, 231, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(16)),
                          ),
                          child:
                              Text('Add Image', style: TextStyle(fontSize: 18)),
                          onPressed: () => uploadFile())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter'),
                  ),
                ),
                Center(
                  // ignore: deprecated_member_use
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(189, 212, 231, 1),
                      ),
                      child: Text('ADD'),
                      onPressed: () {
                        //  dialog(context);
                        // ignore: unnecessary_null_comparison
                        if (img == null || _controller.text.isEmpty ||   selectCategory.id == "id") {
                          setState(() {
                            errortext = 'SomeThing Error';
                          });
                        } else {
                          sendFile(img);

                          setState(() {
                            errortext = null;
                          });
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                activeswitch(),
                Center(
                    child:
                        // ignore: unnecessary_null_comparison
                        errortext == null
                            ? Container()
                            : Text(errortext.toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)))
              ],
            ),
          ),
          imgLoad == true
              ? Center(
                  child: IsLoader(),
                )
              : Container()
        ],
      ),
    );
  }

  void uploadFile() async {
    setState(() {
      imgLoad = true;
    });
    await ImagePickerWeb.getImageInfo.then((value) {
      setState(() {
        img = value.base64;
        showimg = value.data;
        imgLoad = false;
      });
    });
  }

  sendFile(file) {
    Uint8List _bytesData = Base64Decoder().convert(file);
    List<int> _selectedFile = _bytesData;
    var img = base64Encode(_selectedFile);
    context.read<PHP_DB_SubCategory>().addData(
        name: _controller.value.text.toString(),
        image: img,
        categoryId: selectCategory.id.toString(),
        isActive: isSwitched,
        context: context);
  }

  Widget drop() {
    return CusDropDown(
      items: categoryItem(),
      stockWidth: 2,
      height: 40,
      width: 220,
      onChange: (v) {},
      selectName: selectCategory.categoryName,
    );
  }

  Widget activeswitch() {
    return Container(
      width: 500,
      child: Row(
        children: [
          SizedBox(width: 30),
          Text('Is Active',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                debugPrint(isSwitched.toString());
              });
            },
            inactiveThumbColor: Colors.red,
            activeTrackColor: Colors.grey,
            activeColor: Colors.greenAccent,
          ),
          drop()
        ],
      ),
    );
  }

  categoryItem() {
    setState(() {
      isloading = true;
    });
    return context.read<PHP_DB_Category>().data.map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          setState(() {
            selectCategory = CategoryModel(
                categoryName: value.categoryName,
                id: value.id,
                image: value.image,
                isActive: value.isActive,
                createdAt: value.createdAt);
          });
        },
        value: value.categoryName,
        child: Text(value.categoryName.toString()),
      );
    }).toList();
    // ignore: dead_code
    setState(() {
      isloading = false;
    });
  }
}
