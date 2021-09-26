import 'package:flutter/material.dart';
import 'package:web_test/page/product/product_add.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_Group.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:provider/provider.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // category data
      context.read<PHP_DB_Category>().data.isNotEmpty
          ? debugPrint('Data not empty')
          : context.read<PHP_DB_Category>().getData();
      // sub category
      context.read<PHP_DB_SubCategory>().data.isNotEmpty
          ? debugPrint('Data not empty in sub')
          : context.read<PHP_DB_SubCategory>().getData();
      // brand data
      context.read<PHP_DB_Brand>().data.isNotEmpty
          ? debugPrint('Data not empty in brand')
          : context.read<PHP_DB_Brand>().getData();
      // group data
      context.read<PHP_DB_Group>().data.isNotEmpty
          ? debugPrint('Data not empty in brand')
          : context.read<PHP_DB_Group>().getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(189, 212, 231, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          onPressed: () {
            // categoryLoader.getData();
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => ProductAdd()));
          },
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ));
  }
}
