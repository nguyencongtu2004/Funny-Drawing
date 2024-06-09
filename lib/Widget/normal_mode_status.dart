import 'package:draw_and_guess_promax/model/player_normal_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NormalModeStatus extends StatelessWidget {
  const NormalModeStatus({
    super.key,
    required this.word,
    required this.timeLeft,
    required this.isMyTurn,
    required this.userDrawing,
    required this.player,
  });

  final bool isMyTurn;
  final String word;
  final int timeLeft;
  final String userDrawing;
  final PlayerInNormalMode player;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              if (isMyTurn)
                Image.asset(
                  'assets/images/color-palette.png',
                  width: 45,
                  height: 45,
                )
              else
                Image.asset(
                  'assets/images/avatars/avatar${player.avatarIndex}.png',
                  width: 50,
                  height: 50,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isMyTurn ? 'Hãy vẽ: $word' : '$userDrawing đang vẽ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 50,
              child: Container(
                //padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: timeLeft < 10 ? Colors.red : Colors.transparent,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              timeLeft.toString(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
