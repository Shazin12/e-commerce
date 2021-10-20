import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_test/model/brandModel.dart';
import 'package:web_test/model/productModel.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';
import 'package:web_test/service/PHP_DB_Category.dart';
import 'package:web_test/service/PHP_DB_Product.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_SubCategory.dart';
import 'package:web_test/url.dart';

class ProductView extends StatefulWidget {
  final String id;
  const ProductView({Key? key, required this.id}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

TextStyle font = GoogleFonts.getFont('Josefin Sans',
    fontSize: 20, fontWeight: FontWeight.w500);
TextStyle font2 = GoogleFonts.getFont('Josefin Sans', fontSize: 20);
bool moreDetailsShow = false;

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    ProductModel pro = context
        .read<PHP_DB_Product>()
        .allData
        .where((element) => element.id == widget.id)
        .toList()[0];
    return DeviceFrame(
        device: Devices.ios.iPhone11Pro,
        screen: Scaffold(
          body: Container(
              child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(background: mainImage(pro)),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      pro.productName,
                      style: font,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: price(pro),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: delivery(pro),
                  ),
                  GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('More Details', style: font),
                              Icon(
                                moreDetailsShow == false
                                    ? Icons.arrow_drop_down_rounded
                                    : Icons.arrow_drop_up_rounded,
                                size: 35,
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          moreDetailsShow = !moreDetailsShow;
                        });
                      }),
                  moreDetailsShow == true ? moreDetails(pro) : Container(),
                  groupItems(pro)
                ]),
              )
              // bottomPart(pro)
            ],
          )),
        ));
  }

  Widget mainImage(ProductModel pro) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        width: width > 2000 ? 2000 : width,
        height: 400,
        child: FittedBox(
            fit: BoxFit.fill, child: Image.network(imageUrls + pro.mainImage)));
  }

  Widget moreDetails(ProductModel pro) {
    var media = MediaQuery.of(context).size;
    var brand = context
        .read<PHP_DB_Brand>()
        .data
        .where((element) => element.id == pro.brandId)
        .toList();
    var brandName = brand.length > 0 ? brand[0].brandName : "Not Defined";

    var cate = context
        .read<PHP_DB_Category>()
        .data
        .where((element) => element.id == pro.categoryId)
        .toList();
    var cateName = cate.length > 0 ? cate[0].categoryName : "Not Defined";

    var subcate = context
        .read<PHP_DB_SubCategory>()
        .allData
        .where((element) => element.id == pro.subCategoryId)
        .toList();
    var subcateName =
        subcate.length > 0 ? subcate[0].subCategoryName : "Not Defined";
    return AnimatedContainer(
      color: Colors.black26,
      width: media.width,
      height: moreDetailsShow == false ? 0 : 300,
      duration: Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Brand ${brandName.toString()}", style: font2),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Category ${cateName.toString()}", style: font2),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Sub Category ${subcateName.toString()}", style: font2),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(pro.productDes, style: font2),
          )
        ],
      ),
    );
  }

  Widget groupItems(ProductModel pro) {
    List<ProductModel> product = context
        .read<PHP_DB_Product>()
        .allData
        .where((element) => element.groupId == pro.groupId)
        .toList();
    return product.length < 0
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.length,
                itemBuilder: (_, i) {
                  return cardImage(product[i].mainImage, product[i].shotName);
                }),
          );
  }

  Widget price(ProductModel pro) {
    TextStyle style = GoogleFonts.getFont('Josefin Sans',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.lineThrough);
    return Row(
      children: [
        Text('Price', style: font),
        SizedBox(width: 8),
        Text(pro.mrp+" RS", style: style),
        SizedBox(width: 12),
        Text(pro.selling+" RS", style: font),
      ],
    );
  }

  Widget delivery(ProductModel pro) {
    return Text(
        "Delivery Cost ${pro.deliveryCost == '00' ? "Free" : pro.deliveryCost +" RS"}",style:font);
  }

  Widget cardImage(image, text) {
    return Column(
      children: [
        Card(
          elevation: 7,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.all(5),
              height: 80,
              width: 80,
              child: FittedBox(
                  fit: BoxFit.fill, child: Image.network(imageUrls + image))),
        ),
        SizedBox(height: 10),
        Text(text, style: font2)
      ],
    );
  }
}
