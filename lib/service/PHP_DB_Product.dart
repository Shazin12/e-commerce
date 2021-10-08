import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_test/model/productModel.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference<Map<String, dynamic>> _mainCollection =
//     _firestore.collection('categary');
// var storage = FirebaseStorage.instance;

//var urls = 'http://localhost/php-test/api/category/';

// ignore: camel_case_types
class PHP_DB_Product with ChangeNotifier {
  // ADD DATA TO PHP SERVER
  bool dataload = false;
  bool dataAdd = false;
  List<ProductModel> data = [];
  List<ProductModel> allData = [];
  List<ProductModel> searchdata = [];
  // ignore: avoid_init_to_null
  var searchValue = null;
  // ignore: avoid_init_to_null
  String? errorText = null;
  Future<void> addData(
      {required String name,
      required String des,
      required String mainImage,
      required String image1,
      required String image2,
      required String image3,
      required String image4,
      required String image5,
      required bool isActive,
      required bool returnAvailable,
      required String categoryId,
      required String subCategoryId,
      required String brandId,
      required String groupId,
      required String mrp,
      required String stock,
      required String sellingRate,
      required String productCode,
      required String deliveryCost,
      required String shotName,
      required List similarProductId,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "productName": name,
      "productDes": des,
      "mainImage": mainImage,
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "image4": image4,
      "image5": image5,
      "isActive": isActive,
      "returnAvailable": returnAvailable,
      "categoryId": categoryId,
      "subCategoryId": subCategoryId,
      "groupId": groupId,
      "brandId": brandId,
      "stock": stock,
      "mrp": mrp,
      "sellingRate": sellingRate,
      "productCode": productCode,
      "deliveryCost": deliveryCost,
      "similarProductId": similarProductId,
      "shotName": shotName,
    };
    print(shotName);
    var _url = Uri.parse('${urls}product/create.php?api=$api');
    dataAdd = true;
    notifyListeners();
    try {
      await http.post(_url, body: jsonEncode(_map)).then((value) {
        debugPrint('${value.body}');
        succesdialog(context, 'Add Success');
        getData();
        Future.delayed(Duration(seconds: 1)).then((value) {
          dataAdd = false;
          notifyListeners();
        });
      });
    } catch (e) {}
  }

  Future<void> getData() async {
    var _url = Uri.parse('${urls}product/read.php?api=$api');
    try {
      ///////////////
      dataload = true;
      notifyListeners();
      ////////////////
      await http.get(_url).then((value) {
        var message = jsonDecode(value.body)['message'];
        if (message == 'API NOT FOUND' ||
            message == 'API FIELD NOT FOUND' ||
            message == 'NO DATA') {
          dataload = false;
          errorText = errorTextType(message);
          data = [];
          allData = [];
          notifyListeners();
        } else {
          errorText = null;
          notifyListeners();

          List datas = json.decode(value.body)['data'];
          // debugPrint(datas.toString());
          allData = datas.map((e) => ProductModel.fromJson(e)).toList();
          data = datas.map((e) => ProductModel.fromJson(e)).toList();
          notifyListeners();
          searchValue == null
              ? debugPrint('Not In Search Mode')
              : searchValueChanger(searchValue);
          ///////////////
          Future.delayed(Duration(seconds: 1)).then((value) {
            dataload = false;
            notifyListeners();
          });
        }
        ////////////////
      });
    } catch (e) {
      debugPrint(e.toString());
      dataload = false;
      errorText = errorTextType('message');
      data = [];
      notifyListeners();
    }
  }

  Future<void> delete(
      {required String id,
      required String mainImage,
      required String image1,
      required String image2,
      required String image3,
      required String image4,
      required String image5,
      required BuildContext context}) async {
    var _map = {
      "id": id,
      "image0": mainImage,
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "image4": image4,
      "image5": image5,
    };

    var _url = Uri.parse('${urls}product/delete.php?api=$api');
    await http.delete(_url, body: json.encode(_map)).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        getData();
        Future.delayed(Duration(seconds: 1)).then((value) {
          succesdialog(context, 'Delete Success');
        });
      }
    });
  }

  Future<void> updateData(
      {required String id,
      required String name,
      required String des,
      required String mainImage,
      required String image1,
      required String image2,
      required String image3,
      required String image4,
      required String image5,
      required bool isActive,
      required bool returnAvailable,
      required String categoryId,
      required String subCategoryId,
      required String brandId,
      required String groupId,
      required String mrp,
      required String stock,
      required String sellingRate,
      required String productCode,
      required String deliveryCost,
      required List similarProductId,
      required String shotName,
      // old path passing
      required String oldMainImage,
      required String oldImage1,
      required String oldImage2,
      required String oldImage3,
      required String oldImage4,
      required String oldImage5,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "id": id,
      "productName": name,
      "productDes": des,
      "mainImage": mainImage,
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "image4": image4,
      "image5": image5,
      "isActive": isActive,
      "returnAvailable": returnAvailable,
      "categoryId": categoryId,
      "subCategoryId": subCategoryId,
      "groupId": groupId,
      "brandId": brandId,
      "stock": stock,
      "mrp": mrp,
      "sellingRate": sellingRate,
      "productCode": productCode,
      "deliveryCost": deliveryCost,
      "similarProductId": similarProductId,
      "shotName": shotName,
      "oldMainImage": oldMainImage,
      "oldImage1": oldImage1,
      "oldImage2": oldImage2,
      "oldImage3": oldImage3,
      "oldImage4": oldImage4,
      "oldImage5": oldImage5,
    };
    var _url = Uri.parse('${urls}product/update.php?api=$api');
    dataAdd = true;
    notifyListeners();
    try {
      await http.put(_url, body: jsonEncode(_map)).then((value) {
        debugPrint('${value.body}');
        succesdialog(context, 'Update Success');
        getData();
        Future.delayed(Duration(seconds: 1)).then((value) {
          dataAdd = false;
          notifyListeners();
        });
      });
    } catch (e) {}
  }

  Future<void> search(name) async {
    try {
      ///////////////
      dataload = true;
      notifyListeners();
      searchdata = [];
      notifyListeners();
      ////////////////
      searchdata = data
          .where((element) => element.productName
              .toString()
              .toLowerCase()
              .contains(name.toString().toLowerCase()))
          .toList();
      notifyListeners();

      ///////////////
      Future.delayed(Duration(seconds: 1)).then((value) {
        dataload = false;
        notifyListeners();
      });
      ////////////////

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  searchValueChanger(v) {
    searchValue = v;
    notifyListeners();
    search(searchValue);
  }

  ///////////////////////////////////////////////
  succesdialog(context, text) {
    CoolAlert.show(
        barrierDismissible: false,
        context: context,
        type: CoolAlertType.success,
        text: text,
        //  confirmBtnText: 'Ok',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  }

  errordialog(context, text) {
    CoolAlert.show(
        barrierDismissible: false,
        context: context,
        type: CoolAlertType.error,
        text: text,
        //  confirmBtnText: 'Ok',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  }
}
