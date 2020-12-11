class BoardModel {
  int _rowSize;
  int _colSize;
  List<List<bool>> _boardArray;

  void init(int rowSize, int colSize) {
    _rowSize = rowSize;
    _colSize = colSize;
    _boardArray = List.generate(
        _rowSize, (rowIndex) => List.generate(_colSize, (colIndex) => null));
  }

  List<List<bool>> getBoard() {
    return _boardArray;
  }

  List<bool> getRow(int rowIndex) {
    return _boardArray[rowIndex];
  }

  List<bool> getCol(int colIndex) {
    return List.generate(
        _rowSize, (rowIndex) => _boardArray[rowIndex][colIndex],
        growable: false);
  }

  bool getCell(int rowIndex, int colIndex) {
    return _boardArray[rowIndex][colIndex];
  }

  void setRow(int rowIndex, List<bool> rowList) {
    _boardArray[rowIndex] = rowList;
  }

  void setCol(int colIndex, List<bool> colList) {
    for (int rowIndex = 0; rowIndex < _rowSize; rowIndex++) {
      setCell(rowIndex, colIndex, colList[rowIndex]);
    }
  }

  void setCell(int rowIndex, int colIndex, bool value) {
    _boardArray[rowIndex][colIndex] = value;
  }
}
