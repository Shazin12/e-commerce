import 'package:flutter/material.dart';
import 'package:web_test/page/catagory/category.dart';


// ignore: camel_case_types
class D_Drawer extends StatelessWidget {
  const D_Drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [addCatogary(context)],
      ),
    );
  }

  Widget addCatogary(context) {
    // ignore: deprecated_member_use
    return RaisedButton(
        child: Text(
          'Add Catogary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          navpush(context,  CatogaryAdd());
        });
  }

  navpush(context, page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (c) => page));
  }
}
