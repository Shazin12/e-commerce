import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_Group.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';
import 'package:web_test/widget/dropDown.dart';
import 'package:web_test/widget/loader.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

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
  TextEditingController _productController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _mrpController = TextEditingController();
  TextEditingController _sellingController = TextEditingController();
  TextEditingController _proCodeController = TextEditingController();
  TextEditingController _deleviryCostController = TextEditingController();

  String? searchValue = '';

  final formGlobalKey = GlobalKey<FormState>();

  bool isloading = false;
  bool isReturn = true;
  bool isSwitched = false;
  bool imageLoad = false;

  var image0;
  var image1;
  var image2;
  var image3;
  var image4;
  var image5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: bkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  // product and description  ↓ ↓ ↓
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 18),
                        child: field(
                          controller: _productController,
                          hintText: 'Product',
                          validation: (v) => productValidation(v),
                          maxLine: 1,
                          type: TextInputType.text,
                          width: 350,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: field(
                            controller: _desController,
                            width: 350,
                            maxLine: 3,
                            validation: (v) => productDesValidation(v),
                            type: TextInputType.text,
                            hintText: 'Description'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // main image and other 5 image  ↓ ↓ ↓
                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: mainImage(0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainImage(1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: mainImage(2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: mainImage(3),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: mainImage(4),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: mainImage(5),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // is active and is return  ↓ ↓ ↓
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      switchs(
                          text: 'Is Active',
                          value: isSwitched,
                          onchange: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          }),
                      switchs(
                          text: 'Return Availabe',
                          value: isReturn,
                          onchange: (value) {
                            setState(() {
                              isReturn = value;
                            });
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // category and sub category  ↓ ↓ ↓
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: CusDropDown(
                          stockWidth: 2,
                          height: 40,
                          width: 220,
                          items: categoryItem(),
                          onChange: (v) {},
                          selectName: selectCategory.categoryName.toString(),
                        ),
                      ),
                      Container(
                        child: CusDropDown(
                          stockWidth: 2,
                          height: 40,
                          width: 220,
                          items: subcategoryItem(),
                          onChange: (v) {},
                          selectName:
                              selectSubCategory.subCategoryName.toString(),
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
                          items: brandItem(),
                          onChange: (v) {},
                          selectName: brand.brandName.toString(),
                        ),
                      ),
                      Container(
                        child: CusDropDown(
                          stockWidth: 2,
                          height: 40,
                          width: 220,
                          items: groupItem(),
                          onChange: (v) {},
                          selectName: group.groupName.toString(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // stock mrp selling rate  ↓ ↓ ↓
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      field(
                          controller: _stockController,
                          maxLine: 1,
                          hintText: 'Stock',
                          validation: (v) => stockValidation(v),
                          type: TextInputType.number,
                          width: 100),
                      field(
                          controller: _mrpController,
                          maxLine: 1,
                          hintText: 'MRP',
                          validation: (v) => mrpValidation(v),
                          width: 100,
                          type: TextInputType.number),
                      field(
                          controller: _sellingController,
                          maxLine: 1,
                          hintText: 'Sell Rate',
                          width: 100,
                          validation: (v) => sellingValidation(v),
                          type: TextInputType.number),
                    ],
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: field(
                            controller: _proCodeController,
                            maxLine: 1,
                            hintText: 'Product Code',
                            width: 200,
                            validation: (v) => productCodeValidation(v),
                            type: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: field(
                            controller: _deleviryCostController,
                            maxLine: 1,
                            hintText: 'Delivery Cost',
                            width: 200,
                            validation: (v) => deleviryCostValidation(v),
                            type: TextInputType.number),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 20),
                        child: similarPro(),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  button(() {
                    if (formGlobalKey.currentState!.validate()) {
                      appProduct();
                    } else {
                      debugPrint('no');
                    }
                  }, 'Save'),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          imageLoad == true
              ? Center(child: IsLoader())
              : IgnorePointer(
                  ignoring: true, child: Container(width: 1, height: 1))
        ],
      ),
    );
  }

  Widget mainImage(int i) {
    return Column(
      children: [
        removeButton(i),
        InkWell(
            child: Container(
              child: DottedBorder(
                  strokeWidth: 1,
                  dashPattern: [8, 1],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(6),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Center(child: imageShow(i)),
                  )),
            ),
            onTap: () {
              imagePick(imagechange, i);
            }),
      ],
    );
  }

  removeButton(i) {
    return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () => imageRemove(i));
  }

  Widget field(
      {required controller,
      required maxLine,
      required hintText,
      required width,
      required Function validation,
      required TextInputType type}) {
    return Container(
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 5,
              ),
              Text(hintText),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            width: width,
            child: TextFormField(
              inputFormatters: type == TextInputType.number
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              keyboardType: type,
              maxLines: maxLine,
              controller: controller,
              validator: (v) => validation(v),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }

  Widget switchs(
      {required String text,
      required bool value,
      required Function(bool) onchange}) {
    return Container(
      width: 250,
      child: Row(
        children: [
          SizedBox(width: 30),
          Text(text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Switch(
            value: value,
            onChanged: onchange,
            inactiveThumbColor: Colors.red,
            activeTrackColor: Colors.grey,
            activeColor: Colors.greenAccent,
          ),
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
            selectSubCategory = SubCategoryModel(
                subCategoryName: 'Select Sub Category',
                id: 'id',
                image: 'image',
                isActive: ' isActive',
                categoryId: 'categoryId',
                createdAt: 'createdAt');
          });
        },
        value: value.categoryName,
        child: selectedText(selectCategory.id.toString(),
            value.categoryName.toString(), value.id.toString()),
      );
    }).toList();
    // ignore: dead_code
    setState(() {
      isloading = false;
    });
  }

  subcategoryItem() {
    setState(() {
      isloading = true;
    });
    return context
        .read<PHP_DB_SubCategory>()
        .data
        .where((element) => element.categoryId == selectCategory.id)
        .map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          setState(() {
            selectSubCategory = SubCategoryModel(
                subCategoryName: value.subCategoryName,
                id: value.id,
                image: value.image,
                isActive: value.isActive,
                categoryId: value.categoryId,
                createdAt: value.createdAt);
          });
        },
        value: value.subCategoryName,
        child: selectedText(selectSubCategory.id.toString(),
            value.subCategoryName.toString(), value.id.toString()),
      );
    }).toList();
    // ignore: dead_code
    setState(() {
      isloading = false;
    });
  }

  brandItem() {
    setState(() {
      isloading = true;
    });
    return context.read<PHP_DB_Brand>().data.map((value) {
      return DropdownMenuItem<String>(
          onTap: () {
            setState(() {
              brand = BrandModel(
                brandName: value.brandName,
                brandDes: value.brandDes,
                id: value.id,
                createdAt: value.createdAt,
              );
            });
          },
          value: value.brandName,
          child: selectedText(brand.id, value.brandName, value.id));
    }).toList();
    // ignore: dead_code
    setState(() {
      isloading = false;
    });
  }

  groupItem() {
    return context.read<PHP_DB_Group>().data.map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          setState(() {
            group = GroupModel(
              groupName: value.groupName,
              id: value.id,
              createdAt: value.createdAt,
            );
          });
        },
        value: value.groupName,
        child: selectedText(group.id, value.groupName, value.id),
      );
    }).toList();

    // ignore: dead_code
    setState(() {
      isloading = false;
    });
  }

  Widget similarPro() {
    return Container(
      width: 250,
      height: 250,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Similar Product', style: font),
              SizedBox(width: 20),
              button(() {}, 'Pick')
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: bkColor, borderRadius: BorderRadius.circular(14)),
    );
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

  Widget button(Function onPress, text) {
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(189, 212, 231, 1),
          ),
          onPressed: () => onPress(),
          child: Text(
            text,
            style: font,
          )),
    );
  }

  productValidation(v) {
    if (v.isEmpty) {
      return 'Product Name Is Empty';
    } else {
      return null;
    }
  }

  productDesValidation(v) {
    if (v.isEmpty || v == null) {
      return 'Product Description Is Empty';
    } else {
      return null;
    }
  }

  stockValidation(v) {
    if (v.isEmpty || v == null) {
      return 'Empty';
    } else {
      return null;
    }
  }

  sellingValidation(v) {
    if (v.isEmpty || v == null) {
      return 'Empty';
    } else {
      return null;
    }
  }

  mrpValidation(v) {
    if (v.isEmpty || v == null) {
      return 'Empty';
    } else {
      return null;
    }
  }

  productCodeValidation(v) {
    if (v.isEmpty || v == null) {
      return 'Empty';
    } else {
      return null;
    }
  }

  deleviryCostValidation(v) {
    if (v.isEmpty || v == null) {
      return 'Deleviry Cost Is Empty';
    } else {
      return null;
    }
  }

  imagePick(changeValue, i) async {
    setState(() {
      imageLoad = true;
    });
    await ImagePickerWeb.getImage(outputType: ImageType.bytes).then((value) {
      changeValue(value, i);
      setState(() {
        imageLoad = false;
      });
    }).catchError((e) {
      debugPrint(e);
      setState(() {
        imageLoad = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      setState(() {
        imageLoad = false;
      });
    });
  }

  imagechange(v, i) {
  // print(v);
    setState(() {
      if (i == 0)
        return image0 = v;
      else if (i == 1)
        return image1 = v;
      else if (i == 2)
        return image2 = v;
      else if (i == 3)
        return image3 = v;
      else if (i == 4)
        return image4 = v;
      else
        return image5 = v;
    });
  }

  imageRemove(i) {
    setState(() {
      if (i == 0)
        return image0 = null;
      else if (i == 1)
        return image1 = null;
      else if (i == 2)
        return image2 = null;
      else if (i == 3)
        return image3 = null;
      else if (i == 4)
        return image4 = null;
      else
        return image5 = null;
    });
  }

  imageShow(i) {
    if (i == 0)
      return image0 == null ? Text('Main Image') : Image.memory(image0);
    else if (i == 1)
      return image1 == null ? Text('Image 1') : Image.memory(image1);
    else if (i == 2)
      return image2 == null ? Text('Image 2') : Image.memory(image2);
    else if (i == 3)
      return image3 == null ? Text('Image 3') : Image.memory(image3);
    else if (i == 4)
      return image4 == null ? Text('Image 4') : Image.memory(image4);
    else
      return image5 == null ? Text('Image 5') : Image.memory(image5);
  }

  void appProduct() {
    context.read<PHP_DB_Product>().addData(
        name: _productController.text,
        des: _desController.text,
        mainImage: base64Encode(image0),
        image1: base64Encode(image1),
        image2: base64Encode(image2),
        image3: base64Encode(image3),
        image4:image4 == null ? 'null' : base64Encode(image4),
        image5:image5 == null ? 'null' : base64Encode(image5),
        isActive: isSwitched,
        returnAvailable: isReturn,
        categoryId: selectCategory.id.toString(),
        subCategoryId: selectSubCategory.id.toString(),
        brandId: brand.id.toString(),
        groupId: group.id.toString(),
        mrp: _mrpController.text,
        stock: _stockController.text,
        sellingRate: _sellingController.text,
        productCode: _proCodeController.text,
        deliveryCost: _deleviryCostController.text,
        similarProductId: [],
        context: context);
  }
}
