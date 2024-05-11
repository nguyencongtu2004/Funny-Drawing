import 'package:draw_and_guess_promax/Screen/waiting_room.dart';
import 'package:draw_and_guess_promax/Widget/room_mode.dart';
import 'package:draw_and_guess_promax/data/play_mode_data.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:flutter/material.dart';

import '../Widget/button.dart';

class CreateRoom extends StatefulWidget {
  CreateRoom({super.key});

  final TextEditingController _passwordController = TextEditingController();

  int _maxPlayer = 5;

  int get maxPlayer {
    return _maxPlayer;
  }

  set maxPlayer(int value) {
    if (value >= 1 && value <= 10) {
      _maxPlayer = value;
    }
  }

  final selecting = ValueNotifier<String>('none');

  void _startClick(context) {
    print(_passwordController.text);
    print(_maxPlayer);
    print(selecting.value);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => WaitingRoom(
              selectedRoom: Room(
                  roomId: '??????',
                  password: _passwordController.text,
                  isPrivate: _passwordController.text == '' ? false : true,
                  maxPlayer: _maxPlayer,
                  curPlayer: 9999,
                  mode: selecting.value),
              isGuest: true,
            )));
  }

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
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
                      'Tạo phòng',
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
          // Players (bị loại bỏ)
          /*Positioned(
            top: 120,
            left: 0, // Thiết lập left thành 0 để cuộn (chiếm hết không gian)
            right: 0, // Thiết lập right thành 0 để cuộn (chiếm hết không gian)
            child: Column(
              children: [
                Text(
                  'Người chơi trong phòng',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SingleChildScrollView(
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
              ],
            ),
          ),*/
          Positioned(
            top: 100,
            bottom: 120,
            left: 0,
            right: 0,
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Chế độ chơi:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                //Modes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      for (final mode in availabePlayMode)
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print(mode.mode);
                                widget.selecting.value = mode.mode;
                              },
                              child: RoomMode(
                                mode: mode.mode,
                                description: mode.description,
                                selecting: widget.selecting,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                    ],
                  ),
                ),
                // Mật khẩu
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Mật khẩu:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: widget._passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Đặt mật khẩu',
                                  hintStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              // Unfocus keyboard
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Người chơi tối đa:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.maxPlayer--;
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                              width: 25,
                              child: Text(
                                '${widget.maxPlayer}',
                                textAlign: TextAlign.center,
                              )),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.maxPlayer++;
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Nút
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - (180) / 2,
            child: Row(
              children: [
                Button(
                  onClick: (ctx) {
                    widget._startClick(ctx);
                  },
                  title: 'Tạo phòng',
                  imageAsset: 'assets/images/play.png',
                  width: 180,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
