import 'package:draw_and_guess_promax/Widget/player.dart';
import 'package:draw_and_guess_promax/Widget/room_mode.dart';
import 'package:draw_and_guess_promax/data/player_in_room_data.dart';
import 'package:draw_and_guess_promax/Screen/normal_mode_room.dart';
import 'package:flutter/material.dart';

import '../Widget/button.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
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
                      'ID phòng: ??????',
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
          // Players
          Positioned(
            top: 120,
            left: 0, // Thiết lập left thành 0 để cuộn (chiếm hết không gian)
            right: 0, // Thiết lập right thành 0 để cuộn (chiếm hết không gian)
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final player in availablePlayer)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Player(player: player),
                    )
                ],
              ),
            ),
          ),
          //Modes
          Positioned(
            top: 215,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      print('Thường');
                      selecting.value = 'Thường';
                    },
                    child: RoomMode(
                      mode: 'Thường',
                      description: 'Chế độ cơ bản nhất, vẽ và đoán từ.',
                      selecting: selecting,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      print('Tam sao thất bản');
                      selecting.value = 'Tam sao thất bản';
                    },
                    child: RoomMode(
                      mode: 'Tam sao thất bản',
                      description:
                          'Nghệ thuật biến một câu chuyện đơn giản thành... một vở kịch dài tập.',
                      selecting: selecting,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      print('Tuyệt tác');
                      selecting.value = 'Tuyệt tác';
                    },
                    child: RoomMode(
                      mode: 'Tuyệt tác',
                      description:
                          'Chọn 1 từ và biến nó thành tác phẩm nghệ thuật đỉnh cao.',
                      selecting: selecting,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Nút
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - (150 + 20 + 150) / 2,
            child: Row(
              children: [
                Button(
                  onClick: (ctx) {},
                  title: 'Mời',
                  imageAsset: 'assets/images/invite.png',
                  width: 150,
                ),
                const SizedBox(width: 20),
                Button(
                  onClick: (ctx) {Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NormalModeRoom(roomId: selecting.value)));},
                  title: 'Bắt đầu',
                  imageAsset: 'assets/images/play.png',
                  width: 150,
                )
              ],
            ),
          ),
          // đang làm.......
          // có thể sửa thành nút nâng cao để tùy chỉnh mật khẩu + sô người tối đa
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: TextField(
              //controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Đặt mật khẩu',
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
