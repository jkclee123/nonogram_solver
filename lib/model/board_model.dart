import 'dart:io';
import 'package:nonogram_solver/util/range_utils.dart';

class BoardModel {
  int _rowSize;
  List<List<bool>> _boardArray;

  BoardModel(int boardSize) {
    _rowSize = boardSize;
    _boardArray = [
      for (var _ in RangeUtils.range(0, _rowSize))
        [for (var _ in RangeUtils.range(0, _rowSize)) null]
    ];
  }

  int get boardSize => _rowSize;

  void setCell(int rowIndex, int colIndex, bool value) {
    if (_indexOutOfRange(rowIndex, colIndex)) throw ("Index Out Of Range");
    _boardArray[rowIndex][colIndex] = value;
  }

  void consolePrintBoard() {
    print("");
    stdout.write("\n");
    for (int rowIndex in RangeUtils.range(0, _rowSize)) {
      if (rowIndex != 0 && rowIndex % 5 == 0) {
        for (int _ in RangeUtils.range(0, _rowSize)) {
          stdout.write("--");
        }
        stdout.write("\n");
      }
      for (int colIndex in RangeUtils.range(0, _rowSize)) {
        if (colIndex != 0 && colIndex % 5 == 0) {
          stdout.write("| ");
        }
        stdout.write(_getCellDisplay(rowIndex, colIndex));
      }
      stdout.write("\n");
    }
    stdout.write("\n");
  }

  bool getCell(int rowIndex, int colIndex) {
    if (_indexOutOfRange(rowIndex, colIndex)) throw ("Index Out Of Range");
    return _boardArray[rowIndex][colIndex];
  }

  bool _indexOutOfRange(rowIndex, colIndex) =>
      rowIndex < 0 || colIndex < 0 || rowIndex > _rowSize || colIndex > _rowSize
          ? true
          : false;

  String _getCellDisplay(int rowIndex, int colIndex) {
    if (getCell(rowIndex, colIndex) == null) {
      return '  ';
    } else if (getCell(rowIndex, colIndex)) {
      return 'O ';
    } else if (!getCell(rowIndex, colIndex)) {
      return 'X ';
    }
    return '  ';
  }
}
