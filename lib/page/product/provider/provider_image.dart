import 'package:flutter/material.dart';

class ProviderImage with ChangeNotifier {
  var image0;
  var image1;
  var image2;
  var image3;
  var image4;
  var image5;
  bool isLoading = false;

  changeImage0(v) {
    image0 = v;
    notifyListeners();
  }

  changeImage1(v) {
    image1 = v;
    notifyListeners();
  }

  changeImage2(v) {
    image2 = v;
    notifyListeners();
  }

  changeImage3(v) {
    image3 = v;
    notifyListeners();
  }

  changeImage4(v) {
    image4 = v;
    notifyListeners();
  }

  changeImage5(v) {
    image5 = v;
    notifyListeners();
  }

  changeLoadTrue() {
    isLoading = true;
    notifyListeners();
  }

  changeLoadFalse() {
    isLoading = false;
    notifyListeners();
  }

  clear() {
    image0 = null;
    image1 = null;
    image2 = null;
    image3 = null;
    image4 = null;
    image5 = null;
    isLoading = false;
    notifyListeners();
  }
}
