import 'package:flutter/material.dart';

class CustomController extends TextEditingController {

  String? suggestText= "";
  CustomController({String? text,this.suggestText});
  bool isBack(String current, String last) {
    return current.length < last.length;
  }


  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<TextSpan> children = [];
    // debugPrint('text : $text');
    children.add(TextSpan(text: text, style: const TextStyle(color: Colors.black)));
    children.add(TextSpan(text: suggestText, style: TextStyle(color: Colors.grey[500])));
    // debugPrint('text : $text');
    return TextSpan(style: style, children: children);
  }
}