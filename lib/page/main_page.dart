import 'package:flutter/material.dart';
import 'package:nonogram_solver/controller/game_controller.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:nonogram_solver/config/style_config.dart';
import 'package:nonogram_solver/config/const.dart' as Const;
import 'package:mvc_pattern/mvc_pattern.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends StateMVC<MainPage> {
  _MainPageState() : super(GameController()) {
    _gameController = new GameController();
  }
  GameController _gameController;

  @override
  void initState() {
    _gameController.initBoard(10, 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _gameController.initTheme(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          StyleConfig().init(constraints);
          return Center(
              child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.all(20),
                child: Table(
                  border: TableBorder.all(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  children: _boardWidget(),
                ))
          ]));
        }));
  }

  List<TableRow> _boardWidget() {
    _gameController.setCell(2, 6, true);
    _gameController.setCell(1, 6, false);
    List<TableRow> tableRowList = new List<TableRow>();
    for (int rowIndex = 0; rowIndex < 10; rowIndex++) {
      TableRow tableRow = new TableRow(children: []);
      for (int colIndex = 0; colIndex < 10; colIndex++) {
        print(_gameController.getCell(rowIndex, colIndex));
        if (_gameController.getCell(rowIndex, colIndex) == null) {
          tableRow.children.add(_getEmptyCell());
        } else if (_gameController.getCell(rowIndex, colIndex)) {
          tableRow.children.add(_getDotCell());
        } else if (!_gameController.getCell(rowIndex, colIndex)) {
          tableRow.children.add(_getCrossCell());
        }
      }
      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  TableCell _getDotCell() {
    return TableCell(
        child: Container(
      width: 10,
      height: 10,
      color: Colors.black,
    ));
  }

  TableCell _getCrossCell() {
    return TableCell(
        child: Container(
      width: 10,
      height: 10,
      color: Colors.white,
      child: Icon(Icons.cancel_presentation_outlined),
    ));
  }

  TableCell _getEmptyCell() {
    return TableCell(
        child: Container(
      width: 10,
      height: 10,
      color: Colors.white,
    ));
  }
}
