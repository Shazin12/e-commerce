import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_test/model/categoryModel.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference<Map<String, dynamic>> _mainCollection =
//     _firestore.collection('categary');
// var storage = FirebaseStorage.instance;

//var urls = 'http://localhost/php-test/api/category/';

// ignore: camel_case_types
class PHP_DB_Category with ChangeNotifier {
  // ADD DATA TO PHP SERVER
  bool dataload = false;
  bool dataAdd = false;
  List<CategoryModel> data = [];
  List<CategoryModel> searchdata = [];
  // ignore: avoid_init_to_null
  String? errorText = null;
  // ignore: avoid_init_to_null
  var searchValue = null;
  Future<void> addData(
      {required String name,
      required var image,
      required bool isActive,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {"category_name": name, "image": image, "is_active": isActive};
    var _url = Uri.parse('${urls}category/create.php?api=$api');
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
    var _url = Uri.parse('${urls}category/read.php?api=$api');
    try {
      ///////////////
      dataload = true;
      notifyListeners();
      ////////////////
      await http.get(_url).then((value) {
        print(value.statusCode);
        debugPrint(jsonDecode(value.body)['message']);
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
          data = datas.map((e) => CategoryModel.fromJson(e)).toList();
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
    //   debugPrint(id);
    var _url = Uri.parse('${urls}category/delete.php?api=$api');
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
      {required String name,
      required var image,
      required bool isActive,
      required var oldpath,
      required String id,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "category_name": name,
      "image": image,
      "is_active": isActive,
      "id": id,
      "oldpath": oldpath,
    };
    // debugPrint(_map.toString());
    var _url = Uri.parse('${urls}category/update.php?api=$api');
    dataAdd = true;
    print(_map);
    notifyListeners();
    print(_url);
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

  void search(name) async {
    try {
      ///////////////
      dataload = true;
      notifyListeners();
      searchdata = [];
      notifyListeners();
      ////////////////
      searchdata = data
          .where((element) => element.categoryName
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
