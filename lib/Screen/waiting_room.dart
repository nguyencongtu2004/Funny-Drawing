<<<<<<< Thinh
import 'package:draw_and_guess_promax/Screen/normal_mode_room.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
=======
import 'dart:async';

>>>>>>> main
import 'package:draw_and_guess_promax/Widget/player.dart';
import 'package:draw_and_guess_promax/Widget/room_mode.dart';
import 'package:draw_and_guess_promax/data/play_mode_data.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widget/button.dart';
import '../firebase.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';

class WaitingRoom extends ConsumerStatefulWidget {
  const WaitingRoom({
    super.key,
    required this.selectedRoom,
    this.isGuest = true,
  });

  final Room selectedRoom;
  final bool isGuest;

<<<<<<< Thinh
  void _startClick(context) {
=======
  @override
  ConsumerState<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends ConsumerState<WaitingRoom> {
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  var currentPlayers = <User>[];

  @override
  void initState() {
    super.initState();
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');

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

    _playersInRoomRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      setState(() {
        currentPlayers.clear();
        for (var player in data.entries) {
          currentPlayers.add(User(
            id: player.key,
            name: player.value['name'],
            avatarIndex: player.value['avatarIndex'],
          ));
        }
      });
    });
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

  void _startClick() {
>>>>>>> main
    print('bắt đầu');
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => NormalModeRoom(roomId: selectedRoom.roomId)));
  }

  void _inviteClick() {
    print('đã mời');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF00C4A0)),
          ),
          // Appbar
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: Colors.white),
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
                            }

                            await _playOutRoom(ref);
                            Navigator.of(context).pop();
                          },
                          icon: Image.asset('assets/images/back.png'),
                          iconSize: 45,
                        ),
                      ),
                    ),
                    Text(
                      'Phòng chờ',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // id phòng
          Positioned(
            top: 100,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
              child: Text(
                widget.selectedRoom.isPrivate
                    ? 'Id phòng: ${widget.selectedRoom.roomId}\nMật khẩu: ${widget.selectedRoom.password}'
                    : 'Id phòng: ${widget.selectedRoom.roomId}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          // Thông tin
          Positioned(
            top: widget.selectedRoom.isPrivate ? 162 : 138,
            bottom: 120,
            left: 0,
            right: 0,
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                // Text chế độ
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Chế độ:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // Chế độ đã chọn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      RoomMode(
                        mode: widget.selectedRoom.mode,
                        description: availabePlayMode
                            .firstWhere(
                                (mode) => mode.mode == widget.selectedRoom.mode)
                            .description,
                        selecting: ValueNotifier<String>(
                            'bla'), // dòng này không cần thiết nhưng lỡ thiết kế vậy rồi :((
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Người chơi trong phòng (${currentPlayers.length}/${widget.selectedRoom.maxPlayer}):',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // Danh sách người chơi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // Đặt physics là NeverScrollableScrollPhysics() để không cuộn được
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Số cột trong lưới
                      crossAxisSpacing: 20, // Khoảng cách giữa các cột
                      mainAxisSpacing: 20, // Khoảng cách giữa các hàng
                    ),
                    itemCount: currentPlayers.length,
                    // Số lượng avatar
                    itemBuilder: (BuildContext context, int index) {
                      // Tạo một avatar từ index
                      return Player(
<<<<<<< Thinh
                        player: availablePlayer[index],
                        sizeimg: 100,
=======
                        player: currentPlayers[index],
>>>>>>> main
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Nút
          // Khách tham gia phòng
          if (widget.isGuest)
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - (150) / 2,
              child: Row(
                children: [
                  Button(
                    onClick: (ctx) {
                      _inviteClick();
                    },
                    title: 'Mời',
                    imageAsset: 'assets/images/invite.png',
                    width: 150,
                  )
                ],
              ),
            )
          // Chủ phòng
          else
            Positioned(
              bottom: 50,
              left:
                  MediaQuery.of(context).size.width / 2 - (150 + 10 + 150) / 2,
              child: Row(
                children: [
                  Button(
                    onClick: (ctx) {
                      _inviteClick();
                    },
                    title: 'Mời',
                    imageAsset: 'assets/images/invite.png',
                    width: 150,
                  ),
                  const SizedBox(width: 10),
                  Button(
                    onClick: (ctx) {
                      _startClick(ctx);
                    },
                    title: 'Bắt đầu',
                    imageAsset: 'assets/images/play.png',
                    width: 150,
                  )
                ],
              ),
            ),
          // Lời nhắc vui
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              widget.isGuest
                  ? 'Chờ chủ phòng bắt đầu...'
                  : 'Bắt đầu thôi nào!!',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
