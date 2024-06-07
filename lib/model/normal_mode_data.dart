import 'package:draw_and_guess_promax/model/user.dart';

class NormalModeData {
  NormalModeData({
    required this.wordToDraw,
    required this.turn,
    required this.userGuessed,
    this.timeLeft = 60,
  });

  final String wordToDraw;
  final String turn;
  final String? userGuessed;
  int timeLeft;
}
