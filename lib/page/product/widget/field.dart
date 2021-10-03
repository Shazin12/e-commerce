import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CusField extends StatelessWidget {
  TextEditingController controller;
  dynamic maxLine;
  dynamic hintText;
  dynamic width;
  Function validation;
  TextInputType type;

  CusField({
    required this.controller,
    required this.hintText,
    required this.maxLine,
    required this.validation,
    required this.type,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("builded $hintText");
    return field(
        controller: controller,
        maxLine: maxLine,
        hintText: hintText,
        width: width,
        validation: validation,
        type: type);
  }

  Widget field(
      {required controller,
      required maxLine,
      required hintText,
      required width,
      required Function validation,
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
            child: TextFormField(
              inputFormatters: type == TextInputType.number
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              keyboardType: type,
              maxLines: maxLine,
              controller: controller,
              validator: (v) => validation(v),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
