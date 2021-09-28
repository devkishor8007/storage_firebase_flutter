import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String name;
  final Function() onPressed;
  TextButtonWidget({
    required this.name,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          primary: Colors.black,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          )),
      child: Text(name),
    );
  }
}
