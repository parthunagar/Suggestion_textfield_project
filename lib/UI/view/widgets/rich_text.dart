import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  String? title, hint;
  double? titleFontSize, hintFontSize;
  Color? titleColor, hintColor;
  String? titleFontFamily, hintFontFamily;

  RichTextWidget({
    Key? key,
    required this.title,
    required this.titleFontSize,
    required this.titleColor,
    required this.titleFontFamily,
    required this.hint,
    required this.hintFontSize,
    required this.hintColor,
    required this.hintFontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title!,
            style: TextStyle(
              fontSize: titleFontSize,
              color: titleColor ?? Colors.black,
              fontFamily: titleFontFamily,
            ),
          ),
          TextSpan(
            text: hint,
            style: TextStyle(
              fontSize: hintFontSize,
              color: hintColor ?? Colors.grey[400],
              fontFamily: hintFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
