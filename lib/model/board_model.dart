import 'dart:io';
import 'package:nonogram_solver/util/range_utils.dart';

class BoardModel {
  int _boardSize;
  List<List<bool>> _boardArray;

  BoardModel(int boardSize) {
    _boardSize = boardSize;
    _boardArray = [
      for (var _ in RangeUtils.range(0, _boardSize))
        [for (var _ in RangeUtils.range(0, _boardSize)) null]
    ];
  }

  int get boardSize => _boardSize;

  bool getCell(int index) =>
      _getCell(_index2RowIndex(index), _index2ColIndex(index));

  void setCell(int rowIndex, int colIndex, bool value) {
    if (_indexOutOfRange(rowIndex, colIndex)) throw ("Index Out Of Range");
    _boardArray[rowIndex][colIndex] = value;
  }

  void consolePrintBoard() {
    stdout.write("\n");
    for (int rowIndex in RangeUtils.range(0, _boardSize)) {
      if (rowIndex != 0 && rowIndex % 5 == 0) {
        for (int _ in RangeUtils.range(0, _boardSize)) {
          stdout.write("--");
        }
        stdout.write("\n");
      }
      for (int colIndex in RangeUtils.range(0, _boardSize)) {
        if (colIndex != 0 && colIndex % 5 == 0) {
          stdout.write("| ");
        }
        stdout.write(_getCellDisplay(rowIndex, colIndex));
      }
      stdout.write("\n");
    }
    stdout.write("\n");
  }

  bool _getCell(int rowIndex, int colIndex) {
    if (_indexOutOfRange(rowIndex, colIndex)) throw ("Index Out Of Range");
    return _boardArray[rowIndex][colIndex];
  }

  bool _indexOutOfRange(rowIndex, colIndex) => rowIndex < 0 ||
          colIndex < 0 ||
          rowIndex > _boardSize ||
          colIndex > _boardSize
      ? true
      : false;

  int _index2RowIndex(int index) => (index - _boardSize) ~/ _boardSize;

  int _index2ColIndex(int index) => (index - 1) % _boardSize;

  String _getCellDisplay(int rowIndex, int colIndex) {
    if (_getCell(rowIndex, colIndex) == null) {
      return '  ';
    } else if (_getCell(rowIndex, colIndex)) {
      return 'O ';
    } else if (!_getCell(rowIndex, colIndex)) {
      return 'X ';
    }
    return '  ';
  }
}
