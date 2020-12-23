import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nonogram_solver/model/board_model.dart';
import 'package:trotter/trotter.dart';

class GameService extends ControllerMVC {
  GameService([StateMVC state]) : super(state) {
    // dotBoardModel = BoardModel();
    // crossBoardModel = BoardModel();
  }
  BoardModel dotBoardModel;
  BoardModel crossBoardModel;

  void initSolver() {}
}
