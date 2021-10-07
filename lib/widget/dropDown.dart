import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CusDropDown extends StatelessWidget {
  String? selectName;
  List<DropdownMenuItem<String>>? items;
  Function? onChange;
  double? width;
  double? height;
  double? stockWidth;
  CusDropDown(
      {Key? key,
      required this.width,
      required this.stockWidth,
      required this.height,
      required this.selectName,
      required this.items,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: stockWidth!),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.all(5),
          child: DropdownButton<String>(
            underline: Container(),
            isExpanded: true,
            items: items,
            onChanged: (v) {
              onChange!(v);
            },
          )),
      IgnorePointer(
        ignoring: true,
        child: Container(
            width: width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
              child: Center(
                child: Text(
                  selectName!,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )),
      ),
    ]);
  }
}
