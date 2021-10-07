import 'package:flutter/material.dart';
import 'package:web_test/model/productModel.dart';

class ProviderSimilar with ChangeNotifier {
  List<ProductModel> simi = [];

  simiAdd(v) {
    simi.add(v);
    notifyListeners();
  }

  simiRemove(id) {
    simi.removeWhere((pro) => pro.id == id);
    notifyListeners();
  }

  simiClear() {
    simi.clear();
    notifyListeners();
  }
}
