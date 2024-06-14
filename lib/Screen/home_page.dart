import 'dart:math';

import 'package:draw_and_guess_promax/Screen/knock_off_mode_album.dart';
import 'package:draw_and_guess_promax/Widget/pick_avatar_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widget/button.dart';
import '../firebase.dart';
import '../model/room.dart';
import '../model/user.dart';
import '../provider/user_provider.dart'; // Đảm bảo bạn import user_provider đúng cách
import 'create_room.dart';
import 'find_room.dart';
import 'how_to_play.dart';
import 'more_drawer.dart';

Random random = Random();

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  var _avatarIndex = random.nextInt(13);
  var _isWaitingFindRoom = false;
  var _isWaitingCreateRoom = false;

  void _onMoreClick(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const MoreDrawer()));
  }

  void _onInformationClick(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const HowToPlay()));
  }

  void _findRoomClick(context) async {
    String name = _textEditingController.text;
    if (name.isEmpty) {
      // Hiển thị Snackbar nếu tên rỗng
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên của bạn'),
        ),
      );
      return;
    }
    setState(() {
      _isWaitingFindRoom = true;
    });

    final user = ref.watch(userProvider);
    ref
        .watch(userProvider.notifier)
        .updateUser(name: name, avatarIndex: _avatarIndex);

    print('Tên: ${user.name}');
    print('Avatar index: ${user.avatarIndex}');

    final usersRef = database.child('/users/${user.id}');
    await usersRef.update({
      'name': name, // dùng user.name thì bị lỗi trên firebase không thể update
      'avatarIndex': _avatarIndex
    });

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const FindRoom()));
    setState(() {
      _isWaitingFindRoom = false;
    });
  }

  void _createRoomClick(context) async {
    String name = _textEditingController.text;
    if (name.isEmpty) {
      // Hiển thị Snackbar nếu tên rỗng
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên của bạn'),
        ),
      );
      return;
    }
    setState(() {
      _isWaitingCreateRoom = true;
    });

    final user = ref.watch(userProvider);
    ref
        .watch(userProvider.notifier)
        .updateUser(name: name, avatarIndex: _avatarIndex);

    print('Tên: ${user.name}');
    print('Avatar index: ${user.avatarIndex}');

    final usersRef = database.child('/users/${user.id}');
    await usersRef.update({
      'name': name, // dùng user.name thì bị lỗi trên firebase không thể update
      'avatarIndex': _avatarIndex
    });

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => CreateRoom()));
    setState(() {
      _isWaitingCreateRoom = false;
    });
  }

  void _pickAvatar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width * 0.1;
        final height = MediaQuery.of(context).size.height * 0.15;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
          child: PickAvatarDialog(onPick: (index) {
            setState(() {
              _avatarIndex = index;
            });
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF00C4A0), Color(0xFFD05700)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              width: 160,
              height: 150,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!_isWaitingFindRoom && !_isWaitingCreateRoom) {
                      _onMoreClick(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 90),
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    shadowColor: const Color.fromARGB(0, 0, 0, 0),
                    surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Image.asset('assets/images/more.png'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!_isWaitingFindRoom && !_isWaitingCreateRoom) {
                      _onInformationClick(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 90),
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    shadowColor: const Color.fromARGB(0, 0, 0, 0),
                    surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Image.asset('assets/images/information.png'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 220,
            left: 20,
            right: 20,
            child: Container(
              width: 310,
              height: 250,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFFD6FFBE), Color(0xFFC29191)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      if (!_isWaitingFindRoom && !_isWaitingCreateRoom) {
                        _pickAvatar(context);
                      }
                    },
                    child: Container(
                      width: 123.20,
                      height: 123.20,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/avatars/avatar$_avatarIndex.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: const CircleBorder(),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: IconButton(
                                icon: Image.asset('assets/images/edit.png'),
                                onPressed: () {
                                  if (!_isWaitingFindRoom &&
                                      !_isWaitingCreateRoom) {
                                    _pickAvatar(context);
                                  }
                                },
                                padding: const EdgeInsets.all(0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      enabled: !_isWaitingFindRoom && !_isWaitingCreateRoom,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Tên của bạn',
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
            ),
          ),
          Positioned(
            top: 470 + (MediaQuery.of(context).size.height - 470) / 2 - 120 / 2,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                  onClick: _findRoomClick,
                  imageAsset: 'assets/images/search.png',
                  title: 'Tìm phòng',
                  isWaiting: _isWaitingFindRoom,
                  isEnable: !_isWaitingFindRoom && !_isWaitingCreateRoom,
                ),
                const SizedBox(height: 20),
                Button(
                  onClick: _createRoomClick,
                  imageAsset: 'assets/images/plus.png',
                  title: 'Tạo phòng',
                  isWaiting: _isWaitingCreateRoom,
                  isEnable: !_isWaitingFindRoom && !_isWaitingCreateRoom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
