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
import 'package:web_test/page/product/provider/cate_provider.dart';
import 'package:web_test/page/product/provider/provider_image.dart';
import 'package:web_test/page/product/widget/field.dart';
import 'package:web_test/page/product/widget/image.dart';
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
                        child: CusField(
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
                        child: CusField(
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
                        child: CusImage(i: 0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CusImage(i: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CusImage(i: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CusImage(i: 3),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CusImage(i: 4),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CusImage(i: 5),
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
                  Consumer<CateProvider>(builder: (_, v, c) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: CusDropDown(
                            stockWidth: 2,
                            height: 40,
                            width: 220,
                            items: categoryItem(v),
                            onChange: (v) {},
                            selectName:
                                v.selectCategory.categoryName.toString(),
                          ),
                        ),
                        Container(
                          child: CusDropDown(
                            stockWidth: 2,
                            height: 40,
                            width: 220,
                            items: subcategoryItem(v),
                            onChange: (v) {},
                            selectName:
                                v.selectSubCategory.subCategoryName.toString(),
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  // brand and group  ↓ ↓ ↓
                  Consumer<CateProvider>(builder: (_, v, c) {
                    return Row(
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
                    );
                  }),

                  SizedBox(
                    height: 30,
                  ),
                  // stock mrp selling rate  ↓ ↓ ↓
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CusField(
                          controller: _stockController,
                          maxLine: 1,
                          hintText: 'Stock',
                          validation: (v) => stockValidation(v),
                          type: TextInputType.number,
                          width: 100),
                      CusField(
                          controller: _mrpController,
                          maxLine: 1,
                          hintText: 'MRP',
                          validation: (v) => mrpValidation(v),
                          width: 100,
                          type: TextInputType.number),
                      CusField(
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
                        child: CusField(
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
                        child: CusField(
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
          Consumer<ProviderImage>(builder: (_, v, w) {
            return v.isLoading == true
                ? Center(child: IsLoader())
                : IgnorePointer(
                    ignoring: true, child: Container(width: 1, height: 1));
          })
        ],
      ),
    );
  }

  Widget switchs(
      {required String text,
      required bool value,
      required Function(bool) onchange}) {
    return RepaintBoundary(
      child: Container(
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
      ),
    );
  }

  categoryItem(CateProvider c) {
    return context.read<PHP_DB_Category>().data.map((value) {
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
        .read<PHP_DB_SubCategory>()
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
    return context.read<PHP_DB_Brand>().data.map((value) {
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
    return context.read<PHP_DB_Group>().data.map((value) {
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

  void appProduct() {
    ProviderImage image = context.watch<ProviderImage>();
    CateProvider c = context.watch<CateProvider>();
    context.read<PHP_DB_Product>().addData(
        name: _productController.text,
        des: _desController.text,
        mainImage: base64Encode(image.image0),
        image1: base64Encode(image.image1),
        image2: base64Encode(image.image2),
        image3: base64Encode(image.image3),
        image4: image.image4 == null ? 'null' : base64Encode(image.image4),
        image5: image.image5 == null ? 'null' : base64Encode(image.image5),
        isActive: isSwitched,
        returnAvailable: isReturn,
        categoryId: c.selectCategory.id.toString(),
        subCategoryId: c.selectSubCategory.id.toString(),
        brandId: c.brand.id.toString(),
        groupId: c.group.id.toString(),
        mrp: _mrpController.text,
        stock: _stockController.text,
        sellingRate: _sellingController.text,
        productCode: _proCodeController.text,
        deliveryCost: _deleviryCostController.text,
        similarProductId: [],
        context: context);
  }
}
