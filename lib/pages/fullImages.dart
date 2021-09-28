import 'package:flutter/material.dart';
import 'package:flux_firex_storage/model/image_model.dart';

class FullImageShow extends StatefulWidget {
  final ImageModel image;
  FullImageShow({required this.image});

  @override
  _FullImageShowState createState() => _FullImageShowState();
}

class _FullImageShowState extends State<FullImageShow> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Image View"),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Image.network(
            widget.image.image!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
