import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String content;
  final double h, w;

  final TextEditingController txController;
  final String? Function(String?)? validator;

  CustomTextFormField({
    super.key,
    required this.content,
    required this.h,
    required this.w,
    required this.txController,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: txController,
      decoration: InputDecoration(
          hintText: content,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * .05,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(h * .2),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 184, 181, 181))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(h * .2),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 184, 181, 181)))),
    );
  }
}
