import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IsLoader extends StatefulWidget {
  IsLoader({Key? key}) : super(key: key);

  @override
  _IsLoaderState createState() => _IsLoaderState();
}

class _IsLoaderState extends State<IsLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withOpacity(0.8),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Wait....',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.greenAccent,
            )
          ],
        ));
  }
}
