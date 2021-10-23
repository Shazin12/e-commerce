import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:web_test/url.dart';

import '../provider/provider_image.dart';

// ignore: must_be_immutable
class CusImage extends StatelessWidget {
  int i;
  CusImage({Key? key, required this.i}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    print("builder $i");
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
                    radius: Radius.circular(10),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Center(child: imageShow(value, i))),
                    )),
              ),
              onTap: () {
                imagePick(value, i, context);
              }),
          SizedBox(height: 10),
          Text("2000x2000"),
          SizedBox(height: 10),
          errorMessage(value, i)
        ],
      );
    });
  }

  imageShow(ProviderImage value, i) {
    if (i == 0)
      return value.image0 == null
          ? _cusPadding(child: Text('Main Image'))
          : imageNetOrMemory(value.image0);
    else if (i == 1)
      return value.image1 == null
          ? _cusPadding(child: Text('Image 1'))
          : imageNetOrMemory(value.image1);
    else if (i == 2)
      return value.image2 == null
          ? _cusPadding(child: Text('Image 2'))
          : imageNetOrMemory(value.image2);
    else if (i == 3)
      return value.image3 == null || value.image3 == "imageNull"
          ? _cusPadding(child: Text('Image 3'))
          : imageNetOrMemory(value.image3);
    else if (i == 4)
      return value.image4 == null || value.image4 == "imageNull"
          ? _cusPadding(child: Text('Image 4'))
          : imageNetOrMemory(value.image4);
    else
      return value.image5 == null || value.image5 == "imageNull"
          ? _cusPadding(child: Text('Image 5'))
          : imageNetOrMemory(value.image5);
  }

  Widget _cusPadding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: child,
    );
  }

  Widget imageNetOrMemory(v) {
    return v.toString().startsWith("/upload")
        ? Image.network(imageUrls + v)
        : Image.memory(v);
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
    final ImagePicker _picker = ImagePicker();
    values.changeLoadTrue();
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      value == null
          ? debugPrint('NOT SELECTED')
          : imagechanger(values, i, value);
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

  errorMessage(ProviderImage value, int i) {
    if (value.image0 == null && i == 0) {
      return Text(
        'Empty',
        style: TextStyle(color: Colors.red),
      );
    } else if (value.image1 == null && i == 1) {
      return Text(
        'Empty',
        style: TextStyle(color: Colors.red),
      );
    } else if (value.image2 == null && i == 2) {
      return Text(
        'Empty',
        style: TextStyle(color: Colors.red),
      );
    } else if (value.image3 == null && i == 3) {
      return Text(
        'Empty',
        style: TextStyle(color: Colors.red),
      );
    } else {
      return Text('');
    }
  }
}
