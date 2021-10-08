import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/page/product/provider/similar_Provider.dart';
import 'package:web_test/page/product/widget/bottomSheat.dart';
import 'package:web_test/url.dart';
import 'package:provider/provider.dart';

class CusListTitle extends StatelessWidget {

  final ProductModel pro;
  CusListTitle({Key? key,required this.pro})
      : super(key: key);
  final TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);

  @override
  Widget build(BuildContext context) {
     
    return  Padding(
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
                  trailing: remove(pro.id, context),
                ),
              ),
            ));
  }

  Widget remove(id, BuildContext context) {
    return IconButton(
      icon: Icon(Icons.remove_circle_outline),
      onPressed: () {
        context.read<ProviderSimilar>().simiRemove(id);
      },
    );
  }
}
