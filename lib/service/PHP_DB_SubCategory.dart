import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_test/model/subCategoryModel.dart';
import 'package:web_test/url.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference<Map<String, dynamic>> _mainCollection =
//     _firestore.collection('categary');
// var storage = FirebaseStorage.instance;

//var urls = 'http://localhost/php-test/api/category/';

// ignore: camel_case_types
class PHP_DB_SubCategory with ChangeNotifier {
  // ADD DATA TO PHP SERVER
  bool dataload = false;
  bool dataAdd = false;
  List<SubCategoryModel> data = [];
  List<SubCategoryModel> searchdata = [];
  List<SubCategoryModel> allData = [];
  String lastSplitId = 'no';
  // ignore: avoid_init_to_null
  var searchValue = null;
  // ignore: avoid_init_to_null
  String? errorText = null;

  List<SubCategoryModel> outputData = [];
  Future<void> addData(
      {required String name,
      required var image,
      required bool isActive,
      required String categoryId,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "category_id": categoryId,
      "sub_category_name": name,
      "image": image,
      "is_active": isActive
    };
    var _url = Uri.parse('${urls}sub_category/create.php?api=$api');
    dataAdd = true;
    notifyListeners();
    try {
      await http.post(_url, body: jsonEncode(_map)).then((value) {
        print('${value.body}');
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
    var _url = Uri.parse('${urls}sub_category/read.php?api=$api');
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
          notifyListeners();
        } else {
          errorText = null;
          notifyListeners();

          List datas = json.decode(value.body)['data'];

          allData = datas.map((e) => SubCategoryModel.fromJson(e)).toList();
          data = datas.map((e) => SubCategoryModel.fromJson(e)).toList();
          searchValue == null
              ? print('Not In Search Mode')
              : searchValueChanger(searchValue);
          splitData(lastSplitId);
          ///////////////
          Future.delayed(Duration(seconds: 1)).then((value) {
            dataload = false;
            notifyListeners();
          });
        }
        ////////////////
      });
    } catch (e) {
      dataload = false;
      errorText = errorTextType('message');
      data = [];
      notifyListeners();
    }
  }

  Future<void> deleteCategory(
      {required String id,
      required String imagepath,
      required BuildContext context}) async {
    var _map = {"id": id, "imagepath": imagepath};
    //   print(id);
    var _url = Uri.parse('${urls}sub_category/delete.php?api=$api');
    try {
      await http.delete(_url, body: json.encode(_map)).then((value) {
        print(value.body);
        if (value.statusCode == 200) {
          getData();
          // ignore: unnecessary_null_comparison

          Future.delayed(Duration(seconds: 1)).then((value) {
            succesdialog(context, 'Delete Success');
          });
        }
      });
    } catch (e) {}
  }

  Future<void> updateData(
      {required String name,
      required var image,
      required bool isActive,
      required var oldpath,
      required String id,
      required String categoryId,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "category_id": categoryId,
      "sub_category_name": name,
      "image": image,
      "is_active": isActive,
      "id": id,
      "oldpath": oldpath,
    };
    var _url = Uri.parse('${urls}sub_category/update.php?api=$api');
    dataAdd = true;
    notifyListeners();
    try {
      await http.put(_url, body: jsonEncode(_map)).then((value) {
        print('${value.body}');
        succesdialog(context, 'Update Success');
        getData();
        // ignore: unnecessary_null_comparison

        Future.delayed(Duration(seconds: 1)).then((value) {
          dataAdd = false;
          notifyListeners();
        });
      });
    } catch (e) {}
  }

  void search(name) async {
    try {
      ///////////////
      dataload = true;
      notifyListeners();
      searchdata = [];
      notifyListeners();
      ////////////////

      searchdata = data
          .where((element) => element.subCategoryName
              .toString()
              .toLowerCase()
              .contains(name.toString().toLowerCase()))
          .toList();
      notifyListeners();

      ///////////////

      dataload = false;
      notifyListeners();

      ////////////////

    } catch (e) {
      print(e);
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

  splitData(id) {
    lastSplitId = id;
    dataload = true;
    notifyListeners();
    outputData = allData.where((element) => element.categoryId == id).toList();
    id == 'no' ? data = allData : data = outputData;
    notifyListeners();
    Future.delayed(Duration(seconds: 1)).then((value) {
      dataload = false;
      notifyListeners();
    });
  }
}

String errorTextType(message) {
  if (message == 'API NOT FOUND') {
    return 'API NOT FOUND';
  } else if (message == 'API FIELD NOT FOUND') {
    return 'API FIELD NOT FOUND';
  } else if (message == 'NO DATA') {
    return 'NO DATA';
  } else {
    return 'SOMETHING WRONG';
  }
}
