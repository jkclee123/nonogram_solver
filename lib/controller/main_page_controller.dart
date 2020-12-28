import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nonogram_solver/model/solver_model.dart';
import 'package:nonogram_solver/util/range_utils.dart';
import 'package:theme_provider/theme_provider.dart';

class MainPageController extends ControllerMVC {
  MainPageController([StateMVC state]) : super(state) {
    _rowHintControllerList = [];
    _colHintControllerList = [];
    _boardInited = false;
    _solverInited = false;
  }
  int _rowSize;
  ThemeController _themeController;
  bool _boardInited;
  bool _solverInited;
  SolverModel _solverModel;
  List<TextEditingController> _rowHintControllerList;
  List<TextEditingController> _colHintControllerList;

  void initTheme(BuildContext context) =>
      _themeController = ThemeProvider.controllerOf(context);

  void initBoard(int rowSize) {
    if (rowSize == null) throw ("Invalid Board Size");
    _rowSize = rowSize;
    _rowHintControllerList.clear();
    _colHintControllerList.clear();
    _rowHintControllerList = [
      for (var _ in RangeUtils.range(0, _rowSize)) TextEditingController()
    ];
    _colHintControllerList = [
      for (var _ in RangeUtils.range(0, _rowSize)) TextEditingController()
    ];
    _boardInited = true;
    _solverInited = false;
  }

  void initSolver() {
    List<List<int>> rowHintList = _rowHintControllerList
        .map((controller) =>
            controller.text.split(" ").map((hint) => int.parse(hint)).toList())
        .toList();
    List<List<int>> colHintList = _colHintControllerList
        .map((controller) =>
            controller.text.split(" ").map((hint) => int.parse(hint)).toList())
        .toList();
    _solverModel = SolverModel(rowHintList, colHintList);
    _solverInited = true;
  }

  void step() {
    _solverModel.step();
  }

  TextEditingController getHintController(index) {
    if (isRowHintCell(index)) {
      return _rowHintControllerList[index ~/ displayRowSize - 1];
    } else if (isColHintCell(index)) {
      return _colHintControllerList[index - 1];
    }
    return null;
  }

  bool _getCell(int index) {
    // print("$index ${_index2RowIndex(index)} ${_index2ColIndex(index)}");
    return _solverInited
        ? _solverModel.boardModel
            .getCell(_index2RowIndex(index), _index2ColIndex(index))
        : null;
  }

  void nextTheme() => _themeController.nextTheme();

  int get rowSize => _rowSize;

  int get displayRowSize => _rowSize + 1;

  int get displayBoardSize => displayRowSize * displayRowSize;

  bool get boardInited => _boardInited;

  bool isRowHintCell(int index) => index % displayRowSize == 0;

  bool isColHintCell(int index) => index ~/ displayRowSize == 0;

  bool isHintCell(int index) => isRowHintCell(index) || isColHintCell(index);

  bool isDotCell(int index) => !isHintCell(index) && _getCell(index) == true;

  bool isCrossCell(int index) => !isHintCell(index) && _getCell(index) == false;

  bool isHintOrUnknownCell(int index) =>
      isHintCell(index) || _getCell(index) == null;

  Color get defaultCellColor => _themeController.theme.data.cardColor;

  Color get dotCellColor => _themeController.theme.data.iconTheme.color;

  Color get borderColor => _themeController.theme.data.iconTheme.color;

  int _index2RowIndex(int index) => (index - displayRowSize) ~/ displayRowSize;

  int _index2ColIndex(int index) => (index - 1) % displayRowSize;

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
