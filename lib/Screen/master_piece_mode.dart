import 'dart:async';

import 'package:draw_and_guess_promax/Widget/ChatWidget.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/data/word_to_guess.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';

class MasterPieceMode extends ConsumerStatefulWidget {
  const MasterPieceMode({super.key, required this.selectedRoom});

  final Room selectedRoom;

  @override
  createState() => _MasterPieceModeState();
}

class _MasterPieceModeState extends ConsumerState<MasterPieceMode> {
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  late DatabaseReference _chatRef;
  late DatabaseReference _drawingRef;
  late DatabaseReference _normalModeDataRef;

  var _timeLeft = -1;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _drawingRef = database.child('/draw/${widget.selectedRoom.roomId}');
    _chatRef = database.child('/chat/${widget.selectedRoom.roomId}');
    _normalModeDataRef =
        database.child('/normal_mode_data/${widget.selectedRoom.roomId}');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // App bar
        Container(
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(color: Color(0xFF00C4A1)),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset('assets/images/back.png'),
                        iconSize: 45,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tuyệt tác',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose
    super.dispose();
  }
}
