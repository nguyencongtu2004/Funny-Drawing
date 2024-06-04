import 'dart:async';

import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widget/button.dart';
import '../firebase.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';

class KnockoffMode extends ConsumerStatefulWidget {
  const KnockoffMode({super.key, required this.selectedRoom});

  final Room selectedRoom;

  @override
  createState() => _KnockoffModeState();
}

class _KnockoffModeState extends ConsumerState<KnockoffMode> {
  late final _userId;
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  late DatabaseReference _chatRef;
  late DatabaseReference _drawingRef;
  late DatabaseReference _kickoffModeDataRef;
  late final List<User> _playersInRoom = [];
  late List<String> _playersInRoomId = [];
  late DatabaseReference _myDataRef;
  late DatabaseReference _myAlbumRef;

  var _timeLeft = 999;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _userId = ref.read(userProvider).id;
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _drawingRef = database.child('/draw/${widget.selectedRoom.roomId}');
    _chatRef = database.child('/chat/${widget.selectedRoom.roomId}');
    _kickoffModeDataRef =
        database.child('/kickoff_mode_data/${widget.selectedRoom.roomId}');
    _myDataRef = _kickoffModeDataRef.child('/$_userId');
    _myAlbumRef = _kickoffModeDataRef.child('/$_userId/album');

    // Lấy thông tin người chơi trong phòng
    _playersInRoomRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      _playersInRoom.clear();
      for (final player in data.entries) {
        _playersInRoom.add(User(
          id: player.key,
          name: player.value['name'],
          avatarIndex: player.value['avatarIndex'],
        ));
      }
      _playersInRoomId.clear();
      _playersInRoomId = _playersInRoom.map((player) => player.id!).toList();
    });

    // Cập nhật thời gian còn lại
    _myDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      setState(() {
        _timeLeft = data['timeLeft'];
      });
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Hủy Timer nếu đã tồn tại
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _myDataRef.update({'timeLeft': _timeLeft - 1});
      } else {
        timer.cancel(); // Hủy Timer khi thời gian kết thúc
      }
    });
  }

  Future<void> _playOutRoom(WidgetRef ref) async {
    final userId = ref.read(userProvider).id;
    if (userId == null) return;

    if (widget.selectedRoom.roomOwner == userId) {
      await _roomRef.remove();
      await _playersInRoomRef.remove();
      await _chatRef.remove();
      await _kickoffModeDataRef.remove();
    } else {
      final playerRef = database
          .child('/players_in_room/${widget.selectedRoom.roomId}/$userId');
      await playerRef.remove();

      final currentPlayerCount =
          (await _roomRef.child('curPlayer').get()).value as int;
      if (currentPlayerCount > 0) {
        await _roomRef.update({
          'curPlayer': currentPlayerCount - 1,
        });
      }
    }
  }

/*

  // dialog

  late Completer<String> _completer;

  Future<String> _showDialog() async {
    _completer = Completer<String>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var textEditingController = TextEditingController();

        return AlertDialog(
          backgroundColor: const Color(0xFF00C4A1),
          surfaceTintColor: const Color(0xFF00C4A1),
          content: Container(
            width: 310,
            height: 250,
            decoration: ShapeDecoration(
              color: const Color(0xFF00C4A1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            //padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Hãy chọn 1 chủ đề để người khác vẽ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Chủ đề',
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black45),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black45),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Button(
                  width: 100,
                  onClick: (ctx) {
                    if (textEditingController.text.isNotEmpty) {
                      _completer.complete(textEditingController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  title: 'OK ',
                ),
              ],
            ),
          ),
        );
      },
    );
    return _completer.future;
  }

  // end dialog
*/

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
                        onPressed: () {
                          _playOutRoom(ref);
                          Navigator.of(context).pop();
                        },
                        icon: Image.asset('assets/images/back.png'),
                        iconSize: 45,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tam sao thất bản',
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
        Positioned(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Drawing(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              selectedRoom: widget.selectedRoom,
            ),
          ),
        ),
        // Hint
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hãy vẽ thứ gì đó:',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  Text(
                    _timeLeft.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                  Button(
                    onClick: (ctx) {
                      setState(() {
                        _timeLeft = 0;
                      });
                      _myDataRef.update({'timeLeft': _timeLeft});
                    },
                    title: 'Done',
                    color: Colors.greenAccent,
                    width: 102,
                  ),
                ],
              ),
            ),
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
