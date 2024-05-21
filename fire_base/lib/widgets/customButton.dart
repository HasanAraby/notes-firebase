import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.h,
      required this.w,
      required this.color,
      required this.txColor});

  final String text;
  final void Function() onPressed;
  final double h;
  final double w;
  final Color color;
  final Color txColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * .25),
      child: MaterialButton(
          child: Text(text),
          height: h * .06,
          color: color,
          textColor: txColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * .5)),
          onPressed: onPressed),
    );
  }
}
