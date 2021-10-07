import 'package:flutter/material.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:provider/provider.dart';

class Validate {
  commonValidate(v, n) {
    if (v.isEmpty) {
      return '$n Empty';
    } else {
      return null;
    }
  }

  productCodeValidation(v, n, BuildContext context, id) {
    var pro = context.read<PHP_DB_Product>().data.any((p) => p.id == id
        ? false
        : p.productCode.toLowerCase() == v.toString().toLowerCase());

    if (pro == true) {
      return "Code Already Exist";
    } else if (v.isEmpty || v == null) {
      return 'Empty';
    } else {
      return null;
    }
  }
}
