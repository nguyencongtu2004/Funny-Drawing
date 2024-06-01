import 'dart:async';

import 'package:draw_and_guess_promax/Widget/ChatWidget.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';
import '../provider/user_provider.dart';

class NormalModeRoom extends ConsumerStatefulWidget {
  NormalModeRoom({super.key, required this.selectedRoom});

  final Room selectedRoom;

  @override
  ConsumerState<NormalModeRoom> createState() => _NormalModeRoomState();
}

class _NormalModeRoomState extends ConsumerState<NormalModeRoom> {
  // MediaQuery.of(context).size.height
  late String _wordToDraw;
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;

  @override
  void initState() {
    super.initState();
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _wordToDraw = "Con ga";

    _roomRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        // Room has been deleted
        if (widget.selectedRoom.roomOwner != ref.read(userProvider).id) {
          await _showDialog('Phòng đã bị xóa', 'Phòng đã bị xóa bởi chủ phòng',
              isKicked: true);
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _showChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Cho phép Bottom Sheet chiếm nhiều không gian hơn
      backgroundColor: const Color(0xFF00C4A1),
      builder: (ctx) {
        return Container(
          height:
              MediaQuery.of(ctx).size.height * 0.8, // 80% chiều cao màn hình
          child: Chat(
            roomId: widget.selectedRoom.roomId,
            height: MediaQuery.of(ctx).size.height,
            width: MediaQuery.of(ctx).size.width,
          ),
        );
      },
    );
  }

  late Completer<bool> _completer;

  Future<bool> _showDialog(String title, String content,
      {bool isKicked = false}) async {
    _completer = Completer<bool>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          backgroundColor: const Color(0xFF00C4A0),
          actions: [
            if (!isKicked)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _completer.complete(false); // Hoàn thành với giá trị true
                },
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completer.complete(true); // Hoàn thành với giá trị true
              },
              child: Text(
                isKicked ? 'OK' : 'Thoát',
                style: TextStyle(
                  color: isKicked ? Colors.black : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    return _completer.future; // Trả về Future từ Completer
  }

  Future<void> _playOutRoom(WidgetRef ref) async {
    final userId = ref.read(userProvider).id;
    if (userId == null) return;

    if (widget.selectedRoom.roomOwner == userId) {
      // Chủ phòng thoát, xóa phòng
      await _roomRef.remove();
      await _playersInRoomRef.remove();
    } else {
      // Người chơi thoát, xóa người chơi trong phòng
      final playerRef = database
          .child('/players_in_room/${widget.selectedRoom.roomId}/$userId');
      await playerRef.remove();

      // Cập nhật thông tin phòng
      final currentPlayerCount =
          (await _roomRef.child('curPlayer').get()).value as int;
      if (currentPlayerCount > 0) {
        await _roomRef.update({
          'curPlayer': currentPlayerCount - 1,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Appbar
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
                      onPressed: () async {
                        if (ref.read(userProvider).id ==
                            widget.selectedRoom.roomOwner) {
                          final isQuit = await _showDialog('Cảnh báo',
                              'Nếu bạn thoát, phòng sẽ bị xóa và tất cả người chơi khác cũng sẽ bị đuổi ra khỏi phòng. Bạn có chắc chắn muốn thoát không?');
                          if (!isQuit) return;
                        } else {
                          final isQuit = await _showDialog('Cảnh báo',
                              'Bạn có chắc chắn muốn thoát khỏi phòng không?');
                          if (!isQuit) return;
                        }

                        await _playOutRoom(ref);
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset('assets/images/back.png'),
                      iconSize: 45,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _wordToDraw,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: IconButton(
                      onPressed: _showChat,
                      icon: Image.asset('assets/images/chat.png'),
                      iconSize: 45,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Chat
      Positioned(
          //top: 100,
          child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Drawing(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          selectedRoom: widget.selectedRoom,
        ),
      )),
    ]);
  }
}
