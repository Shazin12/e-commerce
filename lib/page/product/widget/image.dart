import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

import '../provider/provider_image.dart';

// ignore: must_be_immutable
class CusImage extends StatelessWidget {
  int i;
  CusImage({Key? key, required this.i}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    print("builder $i");
    var v = context.read<ProviderImage>();
    return Consumer<ProviderImage>(builder: (context, value, child) {
      return Column(
        children: [
          removeButton(value),
          InkWell(
              child: Container(
                child: DottedBorder(
                    strokeWidth: 1,
                    dashPattern: [8, 1],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(6),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Center(child: imageShow(value, i)),
                    )),
              ),
              onTap: () {
                imagePick(value, i, context);
              }),
        ],
      );
    });
  }

  imageShow(ProviderImage value, i) {
    if (i == 0)
      return value.image0 == null
          ? Text('Main Image')
          : Image.memory(value.image0);
    else if (i == 1)
      return value.image1 == null
          ? Text('Image 1')
          : Image.memory(value.image1);
    else if (i == 2)
      return value.image2 == null
          ? Text('Image 2')
          : Image.memory(value.image2);
    else if (i == 3)
      return value.image3 == null
          ? Text('Image 3')
          : Image.memory(value.image3);
    else if (i == 4)
      return value.image4 == null
          ? Text('Image 4')
          : Image.memory(value.image4);
    else
      return value.image5 == null
          ? Text('Image 5')
          : Image.memory(value.image5);
  }

  removeButton(ProviderImage v) {
    return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          imagechanger(v, i, null);
        });
  }

  imagePick(ProviderImage values, i, context) async {
    values.changeLoadTrue();
    await ImagePickerWeb.getImage(outputType: ImageType.bytes).then((value) {
      imagechanger(values, i, value);
      values.changeLoadFalse();
    }).catchError((e) {
      debugPrint(e);
      values.changeLoadFalse();
      print(values.isLoading);
    });
    values.changeLoadFalse();
  }

  void imagechanger(ProviderImage value, i, passingValue) {
    if (i == 0)
      return value.changeImage0(passingValue);
    else if (i == 1)
      return value.changeImage1(passingValue);
    else if (i == 2)
      return value.changeImage2(passingValue);
    else if (i == 3)
      return value.changeImage3(passingValue);
    else if (i == 4)
      return value.changeImage4(passingValue);
    else
      return value.changeImage5(passingValue);
  }
}
