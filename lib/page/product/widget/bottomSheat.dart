import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:provider/provider.dart';
import 'package:web_test/url.dart';

class CusBottomSheet extends StatefulWidget {
  final String? id;
  CusBottomSheet({Key? key, this.id}) : super(key: key);

  @override
  _CusBottomSheetState createState() => _CusBottomSheetState();
}

class _CusBottomSheetState extends State<CusBottomSheet> {
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  List<ProductModel> simi = [];

  @override
  Widget build(BuildContext context) {
    List<ProductModel> pro = context.read<PHP_DB_Product>().data;
    return Container(
      child: ListView.builder(
          itemCount: pro.length,
          itemBuilder: (_, i) {
            return pro[i].id == widget.id ? Container() : tile(pro, i);
          }),
    );
  }

  Widget tile(List<ProductModel> pro, int i) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(imageUrls + pro[i].mainImage))),
            ),
            title: Text(
              pro[i].productName.toString(),
              style: font,
            ),
            trailing: check(pro, i),
          ),
        ),
      ),
    );
  }

  Widget check(List<ProductModel> pro, int i) {
    return Checkbox(
        value: simi.where((e) => e.id == pro[i].id).toList().length > 0
            ? true
            : false,
        onChanged: (v) {
          setState(() {
            v == false
                ? simi.removeWhere((element) => element.id == pro[i].id)
                : simi.add(pro[i]);
          });
        });
  }
}
