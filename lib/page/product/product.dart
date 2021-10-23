import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/page/product/product_edit.dart';
import 'package:web_test/page/product/product_add.dart';
import 'package:web_test/page/product/product_view.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';
import 'package:web_test/widget/dropDown.dart';
import 'package:web_test/widget/table.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool isSearching = false;

  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  debugPrint('rebuild');
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(189, 212, 231, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        onPressed: () {
          //  context.read<PHP_DB_Product>().getData();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => ProductAdd()));
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Product',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(83, 184, 187, 0.0),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                context.read<PHP_DB_Product>().getData();
              },
              icon: Icon(Icons.refresh_outlined))
        ],
      ),
      body: Column(
        children: [
          Consumer<PHP_DB_Product>(builder: (context, v, c) {
            return Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Consumer<PHP_DB_Category>(builder: (context, vv, c) {
                    return CusDropDown(
                        width: 200,
                        stockWidth: 2,
                        height: 40,
                        selectName: v.selectCategory.categoryName,
                        items: categoryItem(v, vv),
                        onChange: (v) {});
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      Consumer<PHP_DB_SubCategory>(builder: (context, vv, c) {
                    return CusDropDown(
                        width: 200,
                        stockWidth: 2,
                        height: 40,
                        selectName: v.selectSubCategory.subCategoryName,
                        items: subcategoryItem(v, vv),
                        onChange: (v) {});
                  }),
                ),
                searchfield()
              ],
            );
          }),
          context.watch<PHP_DB_Product>().dataload == true
              ? Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: CustomTable(
                      updateOn: update,
                      deleteOn: delete,
                      error: context.watch<PHP_DB_Product>().errorText,
                      model: ProductModel,
                      trailIconNeed: true,
                      trailIconFun: (ProductModel i) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProductView(
                                  id: i.id.toString(),
                                )));
                      },
                      data: context.watch<PHP_DB_Product>().data),
                ),
        ],
      ),
    );
  }

  void update(ProductModel i) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ProductEdit(
              id: i.id.toString(),
            )));
  }

  void delete(ProductModel i) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        text:
            'Are You Sure You Wanted To Delete " ${i.productName.toString()} "',
        //  confirmBtnText: 'Ok',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          context.read<PHP_DB_Product>().delete(
              id: i.id,
              mainImage: i.mainImage,
              image1: i.image1,
              image2: i.image2,
              image3: i.image3,
              image4: i.image4,
              image5: i.image5,
              context: context);
        });
  }

  Widget searchfield() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: _controller,
          onChanged: (v) {
            context.read<PHP_DB_Product>().searchValueChanger(v);
          },
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }

  categoryItem(PHP_DB_Product v, PHP_DB_Category vv) {
    return vv.data.map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          v.subcategorySelect(SubCategoryModel(
              subCategoryName: 'Select Sub Category',
              id: 'id',
              image: 'image',
              isActive: ' isActive',
              categoryId: 'categoryId',
              createdAt: 'createdAt'));
          v.categorySelect(value);
          _controller.clear();
        },
        value: value.categoryName,
        child: selectedText(v.selectCategory.id.toString(),
            value.categoryName.toString(), value.id.toString(), () {
          v.categorySelect(CategoryModel(
              categoryName: 'Select Category',
              id: 'id',
              image: 'image',
              isActive: ' isActive',
              createdAt: 'createdAt'));
        }),
      );
    }).toList();
    // ignore: dead_code
  }

  subcategoryItem(PHP_DB_Product v, PHP_DB_SubCategory vv) {
    return vv.data
        .where((element) => element.categoryId == v.selectCategory.id)
        .map((value) {
      return DropdownMenuItem<String>(
        onTap: () {
          v.subcategorySelect(value);
          _controller.clear();
        },
        value: value.subCategoryName,
        child: selectedText(v.selectSubCategory.id.toString(),
            value.subCategoryName.toString(), value.id.toString(), () {
          v.subcategorySelect(SubCategoryModel(
              subCategoryName: 'Select Sub Category',
              id: 'id',
              image: 'image',
              isActive: ' isActive',
              categoryId: 'categoryId',
              createdAt: 'createdAt'));
        }),
      );
    }).toList();
    //
    // ignore: dead_code
  }

  selectedText(String id, String name, String id2, Function onPressed) {
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
            width: id != id2 ? 175 : 130,
            child: Text(
              name.toString(),
              overflow: TextOverflow.ellipsis,
            )),
        Container(
            child: id != id2
                ? Text('')
                : IconButton(
                    onPressed: () => onPressed(),
                    icon: Icon(Icons.bookmark_added_rounded)))
      ],
    );
  }
}
