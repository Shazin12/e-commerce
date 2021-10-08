import 'package:flutter/material.dart';
import 'package:web_test/model/similarModel.dart';

class ProviderSimilar with ChangeNotifier {
  List<Similar> simi = [];

  simiAdd(v) {
    simi.add(Similar(id: v.toString()));
    notifyListeners();
  }

  simiRemove(id) {
    simi.removeWhere((pro) => pro.id == id);
    notifyListeners();
  }

  clear() {
    simi.clear();
    notifyListeners();
  }
  setSimi(List<Similar> v){
    simi = v;
    notifyListeners();
  }
}
