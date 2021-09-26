import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/page/group/group.dart';
import 'package:web_test/page/sub_category/sub_category.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_Group.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';
import 'page/brand/brand.dart';
import 'page/catagory/category.dart';
import 'page/product/product.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class D_Home extends StatefulWidget {
  const D_Home({Key? key}) : super(key: key);

  @override
  _D_HomeState createState() => _D_HomeState();
}

// ignore: camel_case_types
class _D_HomeState extends State<D_Home> {
  int _selectedIndex = 0;
  List where = [
    Brand(),
    CatogaryAdd(),
    SubCategory(),
    Product(),
    Group(),
    Brand(),

    // Brand()
  ];

  TextStyle style = GoogleFonts.getFont('Josefin Sans', fontSize: 17);

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
    var media = MediaQuery.of(context);
    return  Container(
            child: Stack(
            children: [
              Container(
                width: media.size.width,
                height: media.size.height,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Color.fromRGBO(189, 212, 231, 1),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      sideBar('DashBoard', Icons.dashboard_outlined, 0),
                      sideBar('Category', Icons.dashboard_outlined, 1),
                      sideBar('Sub Category', Icons.dashboard_outlined, 2),
                      sideBar('Product', Icons.dashboard_outlined, 3),
                      sideBar('Group', Icons.dashboard_outlined, 4),
                      sideBar('Brand', Icons.dashboard_outlined, 5),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: media.size.width > 700 ? 160 : 40,
                    ),
                    Expanded(
                      child: Container(
                        width: media.size.width,
                        height: media.size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: media.size.width,
                            height: media.size.height,
                            //  color: Colors.black,
                            child: where[_selectedIndex],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[850]
                                    : bkColor,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
  }

  Widget sideBar(String title, IconData icon, int int) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Column(children: [
        ListTile(
          leading: Icon(icon),
          title: Text(media.size.width > 700 ? title : '', style: style),
          onTap: () {
            setState(() {
              _selectedIndex = int;
            });
          },
        ),
        Row(
          children: [
            SizedBox(width: 15),
            AnimatedContainer(
              duration: Duration(milliseconds: 900),
              width: media.size.width > 700
                  ? _selectedIndex == int
                      ? 150
                      : 0
                  : _selectedIndex == int
                      ? 27
                      : 0,
              height: _selectedIndex == int ? 2 : 0,
              color: Colors.white,
            ),
          ],
        )
      ]),
    );
  }

  bool dataload() {
    if (context.watch<PHP_DB_Category>().dataload == true ||
        context.watch<PHP_DB_SubCategory>().dataload == true ||
        context.watch<PHP_DB_Brand>().dataload == true ||
        context.watch<PHP_DB_Group>().dataload == true) {
      return true;
    } else {
      return false;
    }
  }
}
/*
MediaQuery.of(context).size.width < 550
        ? const Center(
            child: Text('Not Response'),
          )
        : Row(
            children: [
              NavigationRail(
                leading: const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 50),
                  child: CircleAvatar(
                    radius: 20,
                  ),
                ),
                backgroundColor: const Color.fromRGBO(189, 212, 231, 1),
                minWidth: 40,
                minExtendedWidth: 150,
                labelType: NavigationRailLabelType.selected,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.dashboard,
                    ),
                    selectedIcon: Icon(
                      Icons.dashboard_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.auto_awesome_mosaic),
                    selectedIcon: Icon(
                      Icons.auto_awesome_mosaic_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.auto_awesome_motion,
                    ),
                    selectedIcon: Icon(
                      Icons.auto_awesome_motion_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Sub Category',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.print_outlined,
                    ),
                    selectedIcon: Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Product',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(child: where[_selectedIndex]),
              ),
            ],
          );
  }
 */
