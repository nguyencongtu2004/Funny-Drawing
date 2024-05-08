import 'package:draw_and_guess_promax/Widget/Button.dart';
import 'package:draw_and_guess_promax/Widget/play_mode.dart';
import 'package:flutter/material.dart';

class FindRoom extends StatefulWidget {
  const FindRoom({super.key});

  @override
  State<FindRoom> createState() => _FindRoomState();
}

class _FindRoomState extends State<FindRoom> {
  final selecting = ValueNotifier<String>('none');

  void _onStartClick(BuildContext context) {
    print(selecting.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Nền
        Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF00C4A0))),
        // Appbar
        Container(
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
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
                    'Phòng có sẵn',
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
        Column(
          children: [
            const SizedBox(height: 120),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  selecting.value = 'Thường';
                },
                child: PlayMode(
                  title: 'Thường',
                  imageAsset: 'assets/images/thuong_mode.png',
                  roomId: '??????',
                  isLocked: false,
                  selecting: selecting,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  selecting.value = 'Tam sao thất bản';
                },
                child: PlayMode(
                  title: 'Tam sao thất bản',
                  imageAsset: 'assets/images/tam_sao_that_ban_mode.png',
                  roomId: '??????',
                  isLocked: true,
                  selecting: selecting,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  selecting.value = 'Tuyệt tác';
                },
                child: PlayMode(
                  title: 'Tuyệt tác',
                  imageAsset: 'assets/images/tuyet_tac_mode.png',
                  roomId: '??????',
                  isLocked: false,
                  selecting: selecting,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 50,
          left: MediaQuery.of(context).size.width / 2 - 180 / 2,
          child: Row(
            children: [
              Button(
                onClick: _onStartClick,
                title: 'Bắt đầu',
                imageAsset: 'assets/images/play.png',
              )
            ],
          ),
        )
      ]),
    );
  }
}
