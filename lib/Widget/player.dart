import 'package:draw_and_guess_promax/model/player_in_room.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
    required this.player,
  });

  final PlayerInRoom player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const ShapeDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/avatar.png'),
              fit: BoxFit.fill,
            ),
            shape: CircleBorder(),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          player.name,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ],
    );
  }
}
