import 'package:flutter/material.dart';

class Const {

  static Type ifelse<Type>(
      bool condition, {
        required Type valid,
        required Type invalid,
      }) {
    return condition ? valid : invalid;
  }
}