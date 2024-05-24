import 'package:draw_and_guess_promax/model/player_in_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/user.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
    required this.player,
    required this.sizeimg,
  });

<<<<<<< Thinh
  final PlayerInRoom player;
  final double sizeimg;
=======
  final User player;
>>>>>>> main

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizeimg,
      height: sizeimg,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/avatars/avatar${player.avatarIndex}.png'), // Sử dụng AssetImage như là ImageProvider
            ),
          ),
          const SizedBox(width: 5),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Text(
              player.name,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
