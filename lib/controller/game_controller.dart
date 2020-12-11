import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nonogram_solver/model/board_model.dart';
import 'package:theme_provider/theme_provider.dart';

class GameController extends ControllerMVC {
  GameController([StateMVC state]) : super(state) {
    _answerBoardModel = BoardModel();
    _boardInited = false;
  }
  BoardModel _answerBoardModel;
  ThemeController _themeController;
  int _rowSize;
  int _colSize;
  bool _boardInited;

  void initTheme(BuildContext context) =>
      _themeController = ThemeProvider.controllerOf(context);

  void initBoard() {
    if (_rowSize != null && _colSize != null) {
      _answerBoardModel.init(_rowSize, _colSize);
      _boardInited = true;
    }
  }

  bool getCell(int rowIndex, int colIndex) =>
      _answerBoardModel.getCell(rowIndex, colIndex);

  void setCell(int rowIndex, int colIndex, bool value) =>
      _answerBoardModel.setCell(rowIndex, colIndex, value);

  void nextTheme() => _themeController.nextTheme();

  void setSize(int rowSize, int colSize) {
    _rowSize = rowSize;
    _colSize = colSize;
  }

  int get boardRowSize => _rowSize;

  int get boardColSize => _colSize;

  bool get boardInited => _boardInited;
}
