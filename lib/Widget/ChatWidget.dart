import 'package:draw_and_guess_promax/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';
import '../model/user.dart';
import 'ChatArea.dart';
import 'player.dart';

class Chat extends StatefulWidget {
  const Chat({
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
      resizeToAvoidBottomInset: true,
      // Đảm bảo nội dung không bị che bởi bàn phím
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF00C4A1),
          borderRadius: BorderRadius.only(
              //topLeft: Radius.circular(25),
              //topRight: Radius.circular(25),
              ),
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final player in _playersInRoom)
                      Player(player: player, sizeImg: 80),
                  ],
                ),
              ),
            ),
            const Divider(height: 10, color: Colors.white),
            Expanded(
              child: ChatArea(
                roomId: widget.roomId,
                width: width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
