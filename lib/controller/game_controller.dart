import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nonogram_solver/model/board_model.dart';
import 'package:nonogram_solver/service/game_service.dart';
import 'package:theme_provider/theme_provider.dart';

class GameController extends ControllerMVC {
  GameController([StateMVC state]) : super(state) {
    // _answerBoardModel = BoardModel();
    _boardInited = false;
    _rowHintControllerList = [];
    _colHintControllerList = [];
    _gameService = GameService();
  }
  GameService _gameService;
  BoardModel _answerBoardModel;
  ThemeController _themeController;
  int _rowSize;
  int _colSize;
  bool _boardInited;
  List<TextEditingController> _rowHintControllerList;
  List<TextEditingController> _colHintControllerList;

  void initTheme(BuildContext context) =>
      _themeController = ThemeProvider.controllerOf(context);

  bool initBoard() {
    if (_rowSize != null && _colSize != null) {
      // _answerBoardModel.init(_rowSize, _colSize);
      _rowHintControllerList.clear();
      _colHintControllerList.clear();
      _rowHintControllerList =
          List.generate(_rowSize, (_) => TextEditingController());
      _colHintControllerList =
          List.generate(_colSize, (_) => TextEditingController());
      _boardInited = true;
      return true;
    }
    return false;
  }

  bool initSolver() {
    List<List<int>> rowHintList = List.generate(
        _rowSize,
        (index) => _rowHintControllerList[index]
            .text
            .split(" ")
            .map((hintStr) => int.tryParse(hintStr) ?? 0));
    List<List<int>> colHintList = List.generate(
        _rowSize,
        (index) => _colHintControllerList[index]
            .text
            .split(" ")
            .map((hintStr) => int.tryParse(hintStr)));

    List<int> rowHintSumList = List.generate(_rowSize,
        (index) => rowHintList[index].reduce((sum, hint) => sum + hint + 1));
    List<int> colHintSumList = List.generate(_colSize,
        (index) => colHintList[index].reduce((sum, hint) => sum + hint + 1));
    if (rowHintSumList.any((hintSum) => hintSum > _rowSize) ||
        colHintSumList.any((hintSum) => hintSum > _colSize)) {
      return false;
    }
    return true;
  }

  TextEditingController getHintController(index) {
    if (isRowHintCell(index)) {
      return _rowHintControllerList[index ~/ boardColSize - 1];
    } else if (isColHintCell(index)) {
      return _colHintControllerList[index - 1];
    }
    return null;
  }

  bool _getCell(int index) {
    int rowIndex = _index2RowIndex(index);
    int colIndex = _index2ColIndex(index);
    if (rowIndex >= 0 &&
        rowIndex < _rowSize &&
        colIndex >= 0 &&
        colIndex < _colSize) {
      // return _answerBoardModel.getCell(rowIndex, colIndex);
      return true;
    }
    return null;
  }

  void setCell(int rowIndex, int colIndex, bool value) =>
      _answerBoardModel.setCell(rowIndex, colIndex, value);

  void nextTheme() => _themeController.nextTheme();

  void setSize(int rowSize, int colSize) {
    _rowSize = rowSize;
    _colSize = colSize;
  }

  int get boardRowSize => _rowSize + 1;

  int get boardColSize => _colSize + 1;

  int get boardSize => boardRowSize * boardColSize;

  bool get boardInited => _boardInited;

  bool isRowHintCell(int index) => index % boardColSize == 0;

  bool isColHintCell(int index) => index ~/ boardColSize == 0;

  bool isHintCell(int index) => isRowHintCell(index) || isColHintCell(index);

  bool isDotCell(int index) => _getCell(index) == true;

  bool isCrossCell(int index) => _getCell(index) == false;

  bool isHintOrUnknownCell(int index) =>
      isHintCell(index) || _getCell(index) == null;

  Color get defaultCellColor => _themeController.theme.data.cardColor;

  Color get dotCellColor => _themeController.theme.data.iconTheme.color;

  Color get borderColor => _themeController.theme.data.iconTheme.color;

  int _index2RowIndex(int index) => (index - boardColSize) ~/ boardColSize;

  int _index2ColIndex(int index) => (index - 1) % boardColSize;

  bool boldAllBorder(int index) => isHintCell(index);

  bool boldTopRightBorder(int index) =>
      _index2RowIndex(index) % 5 == 0 && _index2ColIndex(index) % 5 == 4;
  bool boldRightBottomBorder(int index) =>
      _index2RowIndex(index) % 5 == 4 && _index2ColIndex(index) % 5 == 4;
  bool boldBottomLeftBorder(int index) =>
      _index2RowIndex(index) % 5 == 4 && _index2ColIndex(index) % 5 == 0;
  bool boldLeftTopBorder(int index) =>
      _index2RowIndex(index) % 5 == 0 && _index2ColIndex(index) % 5 == 0;

  bool boldTopBorder(int index) => _index2RowIndex(index) % 5 == 0;
  bool boldRightBorder(int index) => _index2ColIndex(index) % 5 == 4;
  bool boldBottomBorder(int index) => _index2RowIndex(index) % 5 == 4;
  bool boldLeftBorder(int index) => _index2ColIndex(index) % 5 == 0;
}
