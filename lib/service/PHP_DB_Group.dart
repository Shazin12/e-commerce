import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_test/model/groupModel.dart';
import 'package:web_test/url.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference<Map<String, dynamic>> _mainCollection =
//     _firestore.collection('categary');
// var storage = FirebaseStorage.instance;

//var urls = 'http://localhost/php-test/api/category/';

// ignore: camel_case_types
class PHP_DB_Group with ChangeNotifier {
  // ADD DATA TO PHP SERVER
  bool dataload = false;
  bool dataAdd = false;
  List<GroupModel> data = [];
  List<GroupModel> searchdata = [];
  // ignore: avoid_init_to_null
  String? errorText = null;
  // ignore: avoid_init_to_null
  var searchValue = null;
  Future<void> addData(
      {required String name, required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "group_name": name,
    };
    var _url = Uri.parse('${urls}group/create.php?api=$api');
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
    var _url = Uri.parse('${urls}group/read.php?api=$api');
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

          data = datas.map((e) => GroupModel.fromJson(e)).toList();
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
      });
    } catch (e) {
      dataload = false;
      errorText = errorTextType('message');
      data = [];
      notifyListeners();
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

  Future<void> deleteCategory(
      {required String id, required BuildContext context}) async {
    var _map = {
      "id": id,
    };
    //   debugPrint(id);
    var _url = Uri.parse('${urls}group/delete.php?api=$api');
    await http.post(_url, body: json.encode(_map)).then((value) {
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
      required String id,
      required BuildContext context}) async {
    //PASSING DATA
    var _map = {
      "group_name": name,
      "id": id,
    };
    var _url = Uri.parse('${urls}group/update.php?api=$api');
    dataAdd = true;
    notifyListeners();
    try {
      await http.post(_url, body: jsonEncode(_map)).then((value) {
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
          .where((element) => element.groupName
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
}
