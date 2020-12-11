import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StyleConfig {
  static double _screenWidth;
  static double _screenHeight;

  static double _edgeInsetsMultiplier = 0.01;

  static double thinBorder = 1.0;
  static double boldBorder = 3.0;

  static double edgeInsets;
  static double boardHeight;
  static double boardWidth;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    edgeInsets = _screenHeight * _edgeInsetsMultiplier;
    boardHeight = _screenWidth >= _screenHeight
        ? _screenHeight * 0.8
        : _screenHeight * 0.8;
    boardWidth = _screenWidth >= _screenHeight
        ? _screenHeight * 0.8
        : _screenWidth * 0.8;
  }
}
