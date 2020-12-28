import 'package:nonogram_solver/model/board_model.dart';
import 'package:nonogram_solver/util/range_utils.dart';
import 'package:trotter/trotter.dart';

class SolverModel {
  List<List<int>> _rowHintList;
  List<List<int>> _colHintList;
  List<List<Set<int>>> _rowCombList;
  List<List<Set<int>>> _colCombList;
  List<Set<int>> _rowBoxSetList;
  List<Set<int>> _rowEmptySetList;
  Set<int> _hintSumSet;
  Map<String, List<Set<int>>> _hintStrHintCombListMap;
  BoardModel _boardModel;

  int get _rowSize => _rowHintList.length;

  BoardModel get boardModel => _boardModel;

  List<int> get _fullList =>
      [for (int index in RangeUtils.range(0, _rowSize)) index];

  Set<int> get _fullSet => Set<int>.of(_fullList);

  List<Set<int>> get _emptySetList =>
      [for (var _ in RangeUtils.range(0, _rowSize)) {}];

  List<List<int>> get _allHintList => _rowHintList + _colHintList;

  SolverModel(List<List<int>> rowHintList, List<List<int>> colHintList) {
    // rowHintList = [
    //   [2, 2],
    //   [5],
    //   [5],
    //   [5],
    //   [7],
    //   [6],
    //   [6],
    //   [6],
    //   [1, 6],
    //   [9]
    // ];
    // colHintList = [
    //   [2],
    //   [1],
    //   [3],
    //   [10],
    //   [10],
    //   [9],
    //   [10],
    //   [10],
    //   [3, 1],
    //   [1]
    // ];
    if (rowHintList == null ||
        colHintList == null ||
        rowHintList.length == 0 ||
        rowHintList.length != colHintList.length ||
        rowHintList.any((hintList) =>
            hintList.reduce((sum, hint) => sum += hint) > rowHintList.length) ||
        colHintList.any((hintList) =>
            hintList.reduce((sum, hint) => sum += hint) > rowHintList.length)) {
      throw ("Invalid Hint lists");
    }
    _rowHintList = rowHintList.toList();
    _colHintList = colHintList.toList();
    _boardModel = BoardModel(_rowSize);
    _buildHintSumSet();
    _buildHintStrHintCombListMap();
    _buildRowBoxSetList();
    _buildRowEmptySetList();
    _fillHintStrHintCombListMap();
    _fillRowCombList();
    _fillColCombList();
  }

  void _buildHintSumSet() {
    _hintSumSet = {
      for (List<int> hintList in _allHintList)
        hintList.reduce((sum, hint) => sum += hint)
    };
  }

  void _buildHintStrHintCombListMap() {
    _hintStrHintCombListMap = {
      for (List<int> hintList in _allHintList) hintList.toString(): []
    };
  }

  void _buildRowBoxSetList() {
    _rowBoxSetList = _emptySetList.toList();
  }

  void _buildRowEmptySetList() {
    _rowEmptySetList = [for (var _ in RangeUtils.range(0, _rowSize)) _fullSet];
  }

  void _fillHintStrHintCombListMap() {
    for (int sum in RangeUtils.range(1, _rowSize + 1)) {
      if (!_hintSumSet.contains(sum)) continue;
      Combinations<int> combos = Combinations(sum, _fullList);
      for (List<int> posList in combos()) {
        List<int> hintCombList = _posList2HintList(posList);
        if (_hintStrHintCombListMap.containsKey(hintCombList.toString())) {
          _hintStrHintCombListMap[hintCombList.toString()].add(posList.toSet());
        }
      }
    }
  }

  List<int> _posList2HintList(List<int> posList) {
    List<int> hintCombList = [];
    int prev = -1;
    int sum = 1;
    for (int pos in posList) {
      if (prev == -1) {
      } else if (pos - prev == 1) {
        sum += 1;
      } else {
        hintCombList.add(sum);
        sum = 1;
      }
      prev = pos;
    }
    hintCombList.add(sum);
    return hintCombList;
  }

  void _fillRowCombList() {
    _rowCombList = [
      for (List<int> hintList in _rowHintList)
        _hintStrHintCombListMap[hintList.toString()].toList()
    ];
  }

  void _fillColCombList() {
    _colCombList = [
      for (List<int> hintList in _colHintList)
        _hintStrHintCombListMap[hintList.toString()].toList()
    ];
  }

  void step() {
    if (isSolved()) return;
    _removeRowComb();
    _removeColComb();
    _setRowCommon();
    _setColCommon();
    _writeBoard();
    _boardModel.consolePrintBoard();
  }

  bool isSolved() {
    List<List<Set<int>>> allCombList = _rowCombList + _colCombList;
    return !allCombList.any((combList) => combList.length > 1);
  }

  void _setRowCommon() {
    for (int rowIndex in RangeUtils.range(0, _rowSize)) {
      _rowBoxSetList[rowIndex] = _rowBoxSetList[rowIndex].union(
          _rowCombList[rowIndex].reduce(
              (commonBox, combList) => combList.intersection(commonBox)));
      _rowEmptySetList[rowIndex] = _rowEmptySetList[rowIndex].intersection(
          _rowCombList[rowIndex]
              .reduce((commonBox, combList) => combList.union(commonBox)));
    }
  }

  void _setColCommon() {
    for (int colIndex in RangeUtils.range(0, _rowSize)) {
      Set<int> commonBox = _colCombList[colIndex]
          .reduce((commonBox, combList) => combList.intersection(commonBox));
      for (int rowIndex in commonBox) {
        _rowBoxSetList[rowIndex].add(colIndex);
      }
      Set<int> commonEmpty = _fullSet.difference(_colCombList[colIndex]
          .reduce((commonBox, combList) => combList.union(commonBox)));
      for (int rowIndex in commonEmpty) {
        _rowBoxSetList[rowIndex].remove(colIndex);
      }
    }
  }

  void _removeRowComb() {
    for (int rowIndex in RangeUtils.range(0, _rowSize)) {
      _rowCombList[rowIndex].removeWhere((combSet) => _removeCombFilter(
          combSet, _rowBoxSetList[rowIndex], _rowEmptySetList[rowIndex]));
    }
  }

  void _removeColComb() {
    List<Set<int>> colBoxSetList = _emptySetList.toList();
    List<Set<int>> colEmptySetList = _emptySetList.toList();
    for (int rowIndex in RangeUtils.range(0, _rowSize)) {
      for (int colIndex in _rowBoxSetList[rowIndex]) {
        colBoxSetList[colIndex].add(rowIndex);
      }
      for (int colIndex in _rowEmptySetList[rowIndex]) {
        colEmptySetList[colIndex].add(rowIndex);
      }
    }
    for (int colIndex in RangeUtils.range(0, _rowSize)) {
      _colCombList[colIndex].removeWhere((combSet) => _removeCombFilter(
          combSet, colBoxSetList[colIndex], colEmptySetList[colIndex]));
    }
  }

  bool _removeCombFilter(Set<int> combSet, Set<int> boxSet, Set<int> emptySet) {
    return boxSet.difference(combSet).length > 0 ||
        _fullSet
                .difference(emptySet)
                .difference(_fullSet.difference(combSet))
                .length >
            0;
  }

  void _writeBoard() {
    for (int rowIndex in RangeUtils.range(0, _rowSize)) {
      for (int colIndex in _rowBoxSetList[rowIndex]) {
        _boardModel.setCell(rowIndex, colIndex, true);
      }
      for (int colIndex in _fullSet.difference(_rowEmptySetList[rowIndex])) {
        _boardModel.setCell(rowIndex, colIndex, false);
      }
    }
  }
}
