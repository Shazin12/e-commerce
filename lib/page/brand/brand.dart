import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/page/brand/brandAdd.dart';
import 'package:web_test/page/brand/brandEdit.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:provider/provider.dart';
import 'package:web_test/widget/table.dart';

class Brand extends StatefulWidget {
  const Brand({Key? key}) : super(key: key);

  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  String? searchValue = '';

  bool isSearching = false;

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   // category data
    //   context.read<PHP_DB_Category>().data.isNotEmpty
    //       ? debugPrint('Data not empty')
    //       : context.read<PHP_DB_Category>().getData();
    //   // sub category
    //   context.read<PHP_DB_SubCategory>().data.isNotEmpty
    //       ? debugPrint('Data not empty in sub')
    //       : context.read<PHP_DB_SubCategory>().getData();
    //   // brand data
    //   context.read<PHP_DB_Brand>().data.isNotEmpty
    //       ? debugPrint('Data not empty in brand')
    //       : context.read<PHP_DB_Brand>().getData();
    //   // group data
    //   context.read<PHP_DB_Group>().data.isNotEmpty
    //       ? debugPrint('Data not empty in brand')
    //       : context.read<PHP_DB_Group>().getData();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // categoryLoader.getData();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => BrandAdd()));
            },
            child: Icon(
              Icons.add,
              size: 35,
            ),
            backgroundColor: Color.fromRGBO(189, 212, 231, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)))),
        appBar: AppBar(
          title: Text(
            'Brand',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(83, 184, 187, 0.0),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  context.read<PHP_DB_Brand>().getData();
                },
                icon: Icon(Icons.refresh_outlined))
          ],
        ),
        body: Column(
          children: [
            searchfield(),
            context.watch<PHP_DB_Brand>().dataload == true
                ? Container(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: CustomTable(
                      updateOn: update,
                      model: BrandModel,
                      deleteOn: delete,
                      error: context.watch<PHP_DB_Brand>().errorText,
                      data: isSearching == false
                          ? context.watch<PHP_DB_Brand>().data
                          : context.watch<PHP_DB_Brand>().searchdata,
                    ),
                  ),
          ],
        ));
  }

  Widget searchfield() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          onChanged: (v) {
            setState(() {
              context.read<PHP_DB_Brand>().searchdata.clear();
              searchValue = v.toString();
              // ignore: avoid_bool_literals_in_conditional_expressions
              isSearching = v.isEmpty ? false : true;
            });
            context.read<PHP_DB_Brand>().searchValueChanger(v.toString());
          },
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }

  void update(BrandModel i) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BrandEdit(
              name: i.brandName,
              des: i.brandDes,
              id: i.id,
            )));
  }

  void delete(BrandModel i) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        text: 'Are You Sure You Wanted To Delete " ${i.brandName.toString()} "',
        //  confirmBtnText: 'Ok',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          context
              .read<PHP_DB_Brand>()
              .deleteCategory(id: i.id.toString(), context: context);
        });
  }
}

/**
 * 
   
 */
