import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nonogram_solver/model/board_model.dart';
import 'package:theme_provider/theme_provider.dart';

class GameController extends ControllerMVC {
  GameController([StateMVC state]) : super(state) {
    _answerBoardModel = new BoardModel();
  }
  BoardModel _answerBoardModel;
  ThemeController _themeController;

  void initTheme(BuildContext context) =>
      _themeController = ThemeProvider.controllerOf(context);

  void initBoard(int rowSize, int colSize) =>
      _answerBoardModel.init(rowSize, colSize);

  bool getCell(int rowIndex, int colIndex) =>
      _answerBoardModel.getCell(rowIndex, colIndex);

  void setCell(int rowIndex, int colIndex, bool value) =>
      _answerBoardModel.setCell(rowIndex, colIndex, value);
}
