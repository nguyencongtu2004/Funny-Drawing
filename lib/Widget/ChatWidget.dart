import 'package:draw_and_guess_promax/Widget/ChatArea.dart';
import 'package:draw_and_guess_promax/data/player_in_room_data.dart';
import 'package:flutter/material.dart';
import 'package:draw_and_guess_promax/Widget/player.dart';
class Chat extends StatefulWidget {
  Chat({
    super.key,
    required this.roomId,
    required this.height,
    required this.width,
  });

  final String roomId;
  final double height;
  final double width;
  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {

  // List<Pl>
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double height = widget.height;
    final double width = widget.width;
    print("height: " + height.toString());
    return Scaffold(
      body: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color(0xFF00C4A1), // Set background color to blue
          borderRadius: BorderRadius.circular(5.0), // Add rounded corners
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              width: width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Player(
                      player: availablePlayer[0],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[1],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[2],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[3],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[3],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[3],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[3],
                      sizeimg: 70,
                    ),
                    Player(
                      player: availablePlayer[3],
                      sizeimg: 70,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 10, color: Colors.white),
            Expanded(
              child: ChatArea(roomId: widget.roomId,width: width),
            ),
          ],

        ),
      )
    );
  }
}