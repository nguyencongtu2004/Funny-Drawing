import 'package:draw_and_guess_promax/Screen/normal_mode_room.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/Widget/player.dart';
import 'package:draw_and_guess_promax/Widget/room_mode.dart';
import 'package:draw_and_guess_promax/data/play_mode_data.dart';
import 'package:draw_and_guess_promax/data/player_in_room_data.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:flutter/material.dart';

import '../Widget/button.dart';

class WaitingRoom extends StatelessWidget {
  WaitingRoom({
    super.key,
    required this.selectedRoom,
    this.isGuest = true,
  });

  final Room selectedRoom;
  final bool isGuest;

  void _startClick(context) {
    print('bắt đầu');
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => NormalModeRoom(roomId: selectedRoom.roomId)));
  }

  void _inviteClick() {
    print('đã mời');
  }

  final selecting = ValueNotifier<String>('none');

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
                          onPressed: () {
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
                  selectedRoom.isPrivate
                      ? 'Id phòng: ${selectedRoom.roomId}\nMật khẩu: ${selectedRoom.password}'
                      : 'Id phòng: ${selectedRoom.roomId}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )),
          // Thông tin
          Positioned(
            top: selectedRoom.isPrivate ? 162 : 138,
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
                        mode: selectedRoom.mode,
                        description: availabePlayMode
                            .firstWhere(
                                (mode) => mode.mode == selectedRoom.mode)
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
                    'Người chơi trong phòng (${availablePlayer.length}/?):',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
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
                    itemCount: availablePlayer.length,
                    // Số lượng avatar
                    itemBuilder: (BuildContext context, int index) {
                      // Tạo một avatar từ index
                      return Player(
                        player: availablePlayer[index],
                        sizeimg: 100,
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
          if (isGuest)
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
                isGuest ? 'Chờ chủ phòng bắt đầu...' : 'Bắt đầu thôi nào!!',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
