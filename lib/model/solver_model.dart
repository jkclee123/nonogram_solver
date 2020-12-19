import 'package:tuple/tuple.dart';

class SolverModel {
  int _rowSize;
  int _colSize;
  // _rowHintList List<List<int>>
  // _colHintList List<List<int>>
  List<List<int>> _rowPossComb;
  List<List<int>> _colPossComb;
  List<int> _rowBoxList;
  List<int> _rowEmptyList;
  // _hintTupleSet Set<Tuple7>
  // _hintSumSet Set<int>
  // hintTupleCombMap Map<Tuple7, List<int>>
}
