import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/model/similarModel.dart';
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/page/product/provider/cate_provider.dart';
import 'package:web_test/page/product/provider/provider_image.dart';
import 'package:web_test/page/product/provider/similar_Provider.dart';
import 'package:web_test/page/product/widget/bottomSheat.dart';
import 'package:web_test/page/product/widget/drop.dart';
import 'package:web_test/page/product/widget/field.dart';
import 'package:web_test/page/product/widget/image.dart';
import 'package:web_test/page/product/widget/validation.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_Group.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';
import 'package:web_test/widget/loader.dart';

import 'widget/similarTitle.dart';

// ignore: must_be_immutable
class ProductEdit extends StatefulWidget {
  String id;
  ProductEdit({Key? key, required this.id}) : super(key: key);

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  TextEditingController _productController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _mrpController = TextEditingController();
  TextEditingController _sellingController = TextEditingController();
  TextEditingController _proCodeController = TextEditingController();
  TextEditingController _deleviryCostController = TextEditingController();
  TextEditingController _groupProductShotName = TextEditingController();

  String? searchValue = '';

  final formGlobalKey = GlobalKey<FormState>();

  bool isloading = false;
  bool isReturn = true;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();

    ProviderImage image = context.read<ProviderImage>();
    CateProvider cate = context.read<CateProvider>();

    PHP_DB_Category category = context.read<PHP_DB_Category>();
    PHP_DB_SubCategory subCategory = context.read<PHP_DB_SubCategory>();
    PHP_DB_Brand brand = context.read<PHP_DB_Brand>();
    PHP_DB_Group group = context.read<PHP_DB_Group>();
    List<ProductModel> pro = context
        .read<PHP_DB_Product>()
        .data
        .where((element) => element.id == widget.id)
        .toList();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        _productController.text = pro[0].productName;
        _desController.text = pro[0].productDes;
        _stockController.text = pro[0].stock;
        _mrpController.text = pro[0].mrp;
        _sellingController.text = pro[0].selling;
        _proCodeController.text = pro[0].productCode;
        _deleviryCostController.text = pro[0].deliveryCost;
        _groupProductShotName.text = pro[0].shotName;
        image.changeImage0(pro[0].mainImage);
        image.changeImage1(pro[0].image1);
        image.changeImage2(pro[0].image2);
        image.changeImage3(pro[0].image3);
        image.changeImage4(pro[0].image4);
        image.changeImage5(pro[0].image5);
        isSwitched = pro[0].isActive == "0" ? true : false;
        isReturn = pro[0].returnAvailable == "0" ? true : false;
        print('////////////////');
        List s = jsonDecode(pro[0].similar.toString()).toList();
        List<Similar> ss = s.map((e) => Similar.fromJson(e)).toList();
        context.read<ProviderSimilar>().setSimi(ss);
        // for (var i = 0; i < s.length ; i++) {
        //   context.read<ProviderSimilar>().simiAdd(s[i]["id"]);
        // }
        //
        //     List s = pro[0].similar.replaceAll('[', '').replaceAll(']', '').split(',') ;

        //  //List r = s as List<Map>;
        //
        //
        // category
        List<CategoryModel> c = category.data
            .where((element) => element.id == pro[0].categoryId)
            .toList();

        CategoryModel cc = cate.selectCategory;

        cate.changeCategory(c.length > 0 ? c[0] : cc);
        // subcategory
        List<SubCategoryModel> sc = subCategory.data
            .where((element) => element.id == pro[0].subCategoryId)
            .toList();

        SubCategoryModel sscc = cate.selectSubCategory;

        cate.changeSubCategory(sc.length > 0 ? sc[0] : sscc);
        // brand
        List<BrandModel> b = brand.data
            .where((element) => element.id == pro[0].brandId)
            .toList();

        BrandModel bb = cate.brand;

        cate.changeBrand(b.length > 0 ? b[0] : bb);
        // group
        List<GroupModel> g = group.data
            .where((element) => element.id == pro[0].groupId)
            .toList();

        GroupModel gg = cate.group;

        cate.changeGroup(g.length > 0 ? g[0] : gg);
      });
    });
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
                          validation: (v, n) => Validate().commonValidate(v, n),
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
                            validation: (v, n) =>
                                Validate().commonValidate(v, n),
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
                  // [category ][sub category] [brand] [group]  ↓ ↓ ↓
                  Drop(),

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
                          validation: (v, n) => Validate().commonValidate(v, n),
                          type: TextInputType.number,
                          width: 100),
                      CusField(
                          controller: _mrpController,
                          maxLine: 1,
                          hintText: 'MRP',
                          validation: (v, n) => Validate().commonValidate(v, n),
                          width: 100,
                          type: TextInputType.number),
                      CusField(
                          controller: _sellingController,
                          maxLine: 1,
                          hintText: 'Sell Rate',
                          width: 100,
                          validation: (v, n) => Validate().commonValidate(v, n),
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
                            validation: (v, h) => Validate()
                                .productCodeValidation(
                                    v, h, context, widget.id),
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
                            validation: (v, n) =>
                                Validate().commonValidate(v, n),
                            type: TextInputType.number),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: CusField(
                            controller: _groupProductShotName,
                            maxLine: 1,
                            hintText: 'Pro Group Shot Name',
                            width: 200,
                            validation: (v, n) =>
                                Validate().commonValidate(v, n),
                            type: TextInputType.text),
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

  Widget similarPro() {
    return Container(
      width: 400,
      height: 250,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Similar Product', style: font),
              SizedBox(width: 20),
              button(() {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      //the rounded corner is created here
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    context: context,
                    builder: (_) {
                      return CusBottomSheet(
                        id: widget.id,
                      );
                    });
              }, 'Pick')
            ],
          ),
          Expanded(child: Consumer<ProviderSimilar>(builder: (_, v, c) {
            return ListView.builder(
                itemCount: v.simi.length,
                itemBuilder: (_, i) {
                  List<ProductModel> pro = context
                      .read<PHP_DB_Product>()
                      .allData
                      .where((element) => element.id == v.simi[i].id)
                      .toList();

                  return pro.isEmpty
                      ? Container()
                      : CusListTitle(
                          pro: pro[0],
                        );
                });
          }))
        ],
      ),
      decoration: BoxDecoration(
          color: bkColor, borderRadius: BorderRadius.circular(14)),
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

  void appProduct() {
    List<ProductModel> pro = context
        .read<PHP_DB_Product>()
        .data
        .where((element) => element.id == widget.id)
        .toList();
    ProviderImage image = context.read<ProviderImage>();
    CateProvider c = context.read<CateProvider>();
    ///////////////////////////////////////////////////////////
    var image0 = image.image0 == null
        ? 'null'
        : image.image0.toString().startsWith("/upload")
            ? image.image0
            : base64Encode(image.image0);
    /////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////
    var image1 = image.image1 == null
        ? 'null'
        : image.image1.toString().startsWith("/upload")
            ? image.image1
            : base64Encode(image.image1);
    /////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////
    var image2 = image.image2 == null
        ? 'null'
        : image.image2.toString().startsWith("/upload")
            ? image.image2
            : base64Encode(image.image2);
    /////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////
    var image3 = image.image3 == null
        ? 'null'
        : image.image3.toString().startsWith("/upload")
            ? image.image3
            : base64Encode(image.image3);
    /////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////
    var image4 = image.image4 == null || image.image4 == "imageNull"
        ? 'null'
        : image.image4.toString().startsWith("/upload")
            ? image.image4
            : base64Encode(image.image4);
    /////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////
    var image5 = image.image5 == null || image.image5 == "imageNull"
        ? 'null'
        : image.image5.toString().startsWith("/upload")
            ? image.image5
            : base64Encode(image.image5);
    /////////////////////////////////////////////////////////////

    context.read<PHP_DB_Product>().updateData(
        id: widget.id,
        oldMainImage: pro[0].mainImage.toString(),
        oldImage1: pro[0].image1.toString(),
        oldImage2: pro[0].image2.toString(),
        oldImage3: pro[0].image3.toString(),
        oldImage4: pro[0].image4.toString(),
        oldImage5: pro[0].image5.toString(),
        name: _productController.text,
        des: _desController.text,
        mainImage: image0,
        image1: image1,
        image2: image2,
        image3: image3,
        image4: image4,
        image5: image5,
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
        shotName: _groupProductShotName.text,
        similarProductId: context
            .read<ProviderSimilar>()
            .simi
            .map((e) => {"id": e.id})
            .toList(),
        context: context);
  }
}
