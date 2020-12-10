import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StyleConfig {
  static double _screenWidth;
  static double _screenHeight;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
  }
}
