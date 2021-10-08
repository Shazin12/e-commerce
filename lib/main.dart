import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_test/home.dart';
import 'package:web_test/page/product/provider/cate_provider.dart';
import 'package:web_test/page/product/provider/provider_image.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_Group.dart';
import 'package:web_test/service/PHP_DB_Product.dart';

import 'page/product/provider/similar_Provider.dart';
import 'service/PHP_DB_Brand.dart';
import 'service/PHP_DB_SubCategory.dart';
//import 'package:ss/signup.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PHP_DB_Category()),
      ChangeNotifierProvider(create: (_) => PHP_DB_SubCategory()),
      ChangeNotifierProvider(create: (_) => PHP_DB_Brand()),
      ChangeNotifierProvider(create: (_) => PHP_DB_Group()),
      ChangeNotifierProvider(create: (_) => PHP_DB_Product()),
      ChangeNotifierProvider(create: (_) => ProviderImage()),
      ChangeNotifierProvider(create: (_) => CateProvider()),
      ChangeNotifierProvider(create: (_) => ProviderSimilar()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   debugPrint("completed");
    //   setState(() {});
    // });
    // context.read<PHP_DB_Category>().getcategory();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color.fromRGBO(189, 212, 231, 1)),
      home: const Scaffold(
        // appBar: AppBar(),
        //drawer: D_Drawer(),
        backgroundColor: Color.fromRGBO(83, 184, 187, 0.2),
        body: D_Home(),
      ),
    );
  }
}
