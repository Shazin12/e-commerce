import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/page/product/provider/cate_provider.dart';
import 'package:web_test/page/product/provider/provider_image.dart';
import 'package:web_test/page/product/provider/similar_Provider.dart';
import 'package:web_test/page/product/widget/bottomSheat.dart';
import 'package:web_test/page/product/widget/drop.dart';
import 'package:web_test/page/product/widget/field.dart';
import 'package:web_test/page/product/widget/image.dart';
import 'package:web_test/page/product/widget/similarTitle.dart';
import 'package:web_test/page/product/widget/validation.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:web_test/url.dart';
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
  TextEditingController _groupProductShotName = TextEditingController();

  String? searchValue = '';

  final formGlobalKey = GlobalKey<FormState>();

  bool isloading = false;
  bool isReturn = true;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      first();
    });
  }

  Future first() async {
    await context.read<ProviderImage>().clear();
    await context.read<CateProvider>().clear();
    await context.read<ProviderSimilar>().clear();
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
                                .productCodeValidation(v, h, context, "id"),
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
                      errordialog(context);
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
                      return CusBottomSheet();
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
    ProviderImage image = context.read<ProviderImage>();
    CateProvider c = context.read<CateProvider>();
    if (image.image0 == null ||
        image.image1 == null ||
        image.image2 == null ||
        image.image3 == null) {
      errordialog(context);
    } else {
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
          shotName: _groupProductShotName.text,
          similarProductId: context
              .read<ProviderSimilar>()
              .simi
              .map((e) => {"id": e.id})
              .toList(),
          context: context);
    }
  }
}

errordialog(context) {
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    'Error',
                    style: font,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Check All Is Correct", style: font)
            ],
          ),
        );
      });
}
