import 'package:flutter/material.dart';
import 'package:nonogram_solver/controller/game_controller.dart';
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
    _gameController.setSize(10, 10);
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
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: _settingsBtnList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _boardWidget(),
            )
          ]));
        }));
  }

  List<Row> _boardWidget() {
    List<Row> rowList = [];
    for (int rowIndex = 0;
        rowIndex < _gameController.boardRowSize;
        rowIndex++) {
      Row row = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: []);
      for (int colIndex = 0;
          colIndex < _gameController.boardColSize;
          colIndex++) {
        row.children.add(_getCell());
      }
      rowList.add(row);
    }
    return rowList;
  }

  Container _getCell() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: new Border.all(color: Colors.grey[500]),
        color: Colors.white,
      ),
    );
  }

  List<Widget> _settingsBtnList() {
    return [
      Padding(
          padding: EdgeInsets.all(20),
          child: RaisedButton(
            color: Colors.amberAccent[400],
            child: Icon(Icons.lightbulb_outline),
            onPressed: () => _gameController.nextTheme(),
          )),
      Padding(
          padding: EdgeInsets.all(20),
          child: RaisedButton(
            color: Colors.redAccent,
            child: Icon(Icons.refresh_outlined),
            onPressed: () {
              setState(() => _gameController.initBoard());
            },
          ))
    ];
  }
}
