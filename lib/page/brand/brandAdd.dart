import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_Brand.dart';

// ignore: must_be_immutable
class BrandAdd extends StatefulWidget {
  BrandAdd({Key? key}) : super(key: key);

  @override
  _BrandAddState createState() => _BrandAddState();
}

class _BrandAddState extends State<BrandAdd> {
  TextEditingController _brandController = TextEditingController();
  TextEditingController _brandDesController = TextEditingController();
  TextStyle font = GoogleFonts.getFont('Bebas Neue', fontSize: 18);
  final form1GlobalKey = GlobalKey<FormState>();
  final form2GlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        SizedBox(height: 25),
        field(
            controller: _brandController,
            maxLine: 1,
            key: form1GlobalKey,
            hintText: 'Brand',
            width: MediaQuery.of(context).size.width * 0.6,
            type: TextInputType.text),
        SizedBox(height: 25),
        field(
            controller: _brandDesController,
            maxLine: 4,
            key: form2GlobalKey,
            hintText: 'Brand Description',
            width: MediaQuery.of(context).size.width * 0.6,
            type: TextInputType.text),
        SizedBox(height: 25),
        button()
      ],
    ));
  }

  Widget field(
      {required controller,
      required maxLine,
      required hintText,
      required width,
      required key,
      required TextInputType type}) {
    return Container(
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 5,
              ),
              Text(hintText),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            width: width,
            child: Form(
              key: key,
              child: TextFormField(
                keyboardType: type,
                maxLines: maxLine,
                controller: controller,
                validator: (v) {
                  if (v!.isEmpty) {
                    return '$hintText Is Empty';
                  }
                  if (hintText != 'Brand Description') {
                    if (context
                            .read<PHP_DB_Brand>()
                            .data
                            .where((element) =>
                                element.brandName.toLowerCase().toString() ==
                                v.toLowerCase().toString())
                            .toList()
                            .length >
                        0) {
                      return 'Already Exist';
                    }
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(189, 212, 231, 1),
          ),
          onPressed: () => sendFile(),
          child: Text(
            'Add',
            style: font,
          )),
    );
  }

  sendFile() {
    if (form1GlobalKey.currentState!.validate() &&
        form2GlobalKey.currentState!.validate()) {
      context.read<PHP_DB_Brand>().addData(
          name: _brandController.text,
          des: _brandDesController.text,
          context: context);
    }
  }
}
