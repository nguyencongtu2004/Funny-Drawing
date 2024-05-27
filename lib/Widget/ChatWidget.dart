import 'package:draw_and_guess_promax/Widget/ChatArea.dart';
import 'package:draw_and_guess_promax/Widget/player.dart';
import 'package:draw_and_guess_promax/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

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
  late DatabaseReference _playerInRoomRef;
  final List<User> _playersInRoom = [];

  @override
  void initState() {
    super.initState();
    _playerInRoomRef = database.child('/players_in_room/${widget.roomId}');
    _playerInRoomRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      setState(() {
        _playersInRoom.clear();
        for (final player in data.entries) {
          _playersInRoom.add(User(
            id: player.key,
            name: player.value['name'],
            avatarIndex: player.value['avatarIndex'],
          ));
        }
      });
    });
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (final player in _playersInRoom)
                    Player(player: player, sizeImg: 60),
                ],
              ),
            ),
          ),
          const Divider(height: 10, color: Colors.white),
          Expanded(
            child: ChatArea(
                roomId: widget.roomId, width: width), // No height needed
          ),
        ],
      ),
    ));
  }
}
