import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/page/product/provider/similar_Provider.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:provider/provider.dart';
import 'package:web_test/url.dart';

// ignore: must_be_immutable
class CusBottomSheet extends StatefulWidget {
  final String? id;
  CusBottomSheet({Key? key, this.id}) : super(key: key);

  @override
  _CusBottomSheetState createState() => _CusBottomSheetState();
}

class _CusBottomSheetState extends State<CusBottomSheet> {
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  String? search;

  Widget build(BuildContext context) {
    return Container(
      child: Consumer<PHP_DB_Product>(
        builder: (_, pro, child) {
          return Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      search = v;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: datas(pro.allData).length,
                    itemBuilder: (_, i) {
                      return datas(pro.allData)[i].id == widget.id
                          ? Container()
                          : tile(datas(pro.allData)[i]);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget tile(ProductModel pro) {
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
                      image: NetworkImage(imageUrls + pro.mainImage))),
            ),
            title: Text(
              pro.productName.toString(),
              style: font,
            ),
            trailing: check(pro),
          ),
        ),
      ),
    );
  }

  Widget check(ProductModel pro) {
    return Consumer<ProviderSimilar>(builder: (_, simis, child) {
      return IconButton(
          onPressed: () {
            simis.simi.where((e) => e.id == pro.id).toList().length > 0
                ? simis.simiRemove(pro.id)
                : simis.simiAdd(pro.id.toString());
            print(simis.simi.toList());

            simis.simi.map((e) => print(e.id));
          },
          icon: Icon(simis.simi.where((e) => e.id == pro.id).toList().length > 0
              ? Icons.check_box_rounded
              : Icons.check_box_outline_blank_rounded));
    });
  }

  List<ProductModel> datas(List<ProductModel> data) {
    if (search == null || search.toString().length< 0) {
      return data;
    } else {
      return data.where((element) => element.productName.toLowerCase().contains(search!.toLowerCase().toString())).toList();
    }
  }
}
