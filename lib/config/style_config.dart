import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StyleConfig {
  static double _screenWidth;
  static double _screenHeight;

  static double _edgeInsetsMultiplier = 0.01;

  static double edgeInsets;
  static double boardHeight;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    edgeInsets = _screenHeight * _edgeInsetsMultiplier;
    boardHeight = _screenHeight * 0.5;
  }
}
