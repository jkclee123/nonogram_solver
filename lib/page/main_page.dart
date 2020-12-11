import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            !_gameController.boardInited
                ? Container()
                : SizedBox(
                    height: StyleConfig.boardHeight,
                    width: StyleConfig.boardWidth,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _gameController.boardColSize),
                      itemBuilder: (_, index) => _getCell(index),
                      itemCount: _gameController.boardSize,
                    ))
          ]));
        }));
  }

  Container _getCell(int index) {
    if (index == 0) {
      return Container();
    } else {
      return Container(
        decoration: BoxDecoration(
          border: _getCellBorder(index),
          color: _getCellColor(index),
        ),
        child: _getCellChild(index),
      );
    }
  }

  Border _getCellBorder(int index) {
    if (_gameController.boldAllBorder(index)) {
      return _getBoldAllBorder();
    } else if (_gameController.boldTopRightBorder(index)) {
      return _getBoldTopRightBorder();
    } else if (_gameController.boldRightBottomBorder(index)) {
      return _getBoldRightBottomBorder();
    } else if (_gameController.boldBottomLeftBorder(index)) {
      return _getBoldBottomLeftBorder();
    } else if (_gameController.boldLeftTopBorder(index)) {
      return _getBoldLeftTopBorder();
    } else if (_gameController.boldTopBorder(index)) {
      return _getBoldTopBorder();
    } else if (_gameController.boldRightBorder(index)) {
      return _getBoldRightBorder();
    } else if (_gameController.boldBottomBorder(index)) {
      return _getBoldBottomBorder();
    } else if (_gameController.boldLeftBorder(index)) {
      return _getBoldLeftBorder();
    } else {
      return _getThinAllBorder();
    }
  }

  Border _getThinAllBorder() {
    return Border.all(
        color: _gameController.borderColor, width: StyleConfig.thinBorder);
  }

  Border _getBoldAllBorder() {
    return Border.all(
        color: _gameController.borderColor, width: StyleConfig.boldBorder);
  }

  Border _getBoldTopRightBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
    );
  }

  Border _getBoldRightBottomBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
    );
  }

  Border _getBoldBottomLeftBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
    );
  }

  Border _getBoldLeftTopBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
    );
  }

  Border _getBoldTopBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
    );
  }

  Border _getBoldRightBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
    );
  }

  Border _getBoldBottomBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
    );
  }

  Border _getBoldLeftBorder() {
    return Border(
      top: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      right: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      bottom: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.thinBorder),
      left: BorderSide(
          color: _gameController.borderColor, width: StyleConfig.boldBorder),
    );
  }

  Color _getCellColor(int index) {
    if (_gameController.isDotCell(index)) {
      return _gameController.dotCellColor;
    } else {
      return _gameController.defaultCellColor;
    }
  }

  Widget _getCellChild(int index) {
    if (_gameController.isHintCell(index)) {
      return TextField(
        controller: _gameController.getHintController(index),
        expands: true,
        maxLines: null,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
        ],
      );
    } else if (_gameController.isCrossCell(index)) {
      return FittedBox(
        fit: BoxFit.fill,
        child: Icon(Icons.clear),
      );
    } else {
      return null;
    }
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
