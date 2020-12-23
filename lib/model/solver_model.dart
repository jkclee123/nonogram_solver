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

  int get _boardSize => _colHintList.length;

  List<int> get _fullList => List.generate(_boardSize, (index) => index);

  Set<int> get _fullSet => Set<int>.of(_fullList);

  List<List<int>> get _allHintList => _rowHintList + _colHintList;

  SolverModel(List<List<int>> rowHintList, List<List<int>> colHintList) {
    if (rowHintList == null ||
        colHintList == null ||
        rowHintList.length != colHintList.length) {
      throw ("Hint lists must not be null");
    }
    // _rowHintList = rowHintList.toList();
    // _colHintList = colHintList.toList();
    _rowHintList = [
      [2, 2],
      [5],
      [5],
      [5],
      [7],
      [6],
      [6],
      [6],
      [1, 6],
      [9]
    ];
    _colHintList = [
      [2],
      [1],
      [3],
      [10],
      [10],
      [9],
      [10],
      [10],
      [3, 1],
      [1]
    ];
    _boardModel = BoardModel(_boardSize);
    _buildHintSumSet();
    _buildHintStrHintCombListMap();
    _buildRowBoxSetList();
    _buildRowEmptySetList();
    _fillHintStrHintCombListMap();
    _fillRowCombList();
    _fillColCombList();
    _boardModel.consolePrintBoard();
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
    _rowBoxSetList = [for (var _ in RangeUtils.range(0, _boardSize)) {}];
  }

  void _buildRowEmptySetList() {
    _rowEmptySetList = [
      for (var _ in RangeUtils.range(0, _boardSize)) _fullSet
    ];
  }

  void _fillHintStrHintCombListMap() {
    for (int sum in RangeUtils.range(1, _boardSize + 1)) {
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
        _hintStrHintCombListMap[hintList.toString()]
    ];
  }

  void _fillColCombList() {
    _colCombList = [
      for (List<int> hintList in _colHintList)
        _hintStrHintCombListMap[hintList.toString()]
    ];
  }

  void _setCommon() {
    _setRowCommon();
    _setColCommon();
  }

  void _setRowCommon() {
    for (int rowIndex in RangeUtils.range(0, _boardSize)) {
      _rowBoxSetList[rowIndex].union(_rowCombList[rowIndex]
          .reduce((commonBox, combList) => combList.intersection(commonBox)));
      _rowEmptySetList[rowIndex].intersection(_rowCombList[rowIndex]
          .reduce((commonBox, combList) => combList.union(commonBox)));
    }
  }

  void _setColCommon() {
    for (int colIndex in RangeUtils.range(0, _boardSize)) {
      Set<int> commonBox = _colCombList[colIndex]
          .reduce((commonBox, combList) => combList.intersection(commonBox));
      for (int rowIndex in commonBox) {
        _rowBoxSetList[rowIndex].add(colIndex);
      }
      Set<int> commonEmpty = _colCombList[colIndex]
          .reduce((commonBox, combList) => combList.union(commonBox));
      for (int rowIndex in commonEmpty) {
        _rowBoxSetList[rowIndex].intersection(Set<int>.of([colIndex]));
      }
    }
  }
}
