import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web_test/service/PHP_DB_Group.dart';

// ignore: must_be_immutable
class GroupAdd extends StatefulWidget {
  GroupAdd({Key? key}) : super(key: key);

  @override
  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  TextEditingController _groupController = TextEditingController();
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
            controller: _groupController,
            maxLine: 1,
            key: form1GlobalKey,
            hintText: 'Group',
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
                  // ignore: unrelated_type_equality_checks
                  if (context.read<PHP_DB_Group>().data.where((element) => element.groupName.toLowerCase().toString() == v.toLowerCase().toString()).toList().length > 0) {
                    return 'Already Exist';
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
    if (form1GlobalKey.currentState!.validate()) {
      context
          .read<PHP_DB_Group>()
          .addData(name: _groupController.text, context: context);
    }
  }
}
