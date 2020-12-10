import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nonogram_solver/model/board_model.dart';

class GameService extends ControllerMVC {
  GameService([StateMVC state]) : super(state) {
    BoardModel dotBoardModel;
    BoardModel crossBoardModel;
  }
}
