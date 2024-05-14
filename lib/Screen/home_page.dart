import 'dart:math';

import 'package:draw_and_guess_promax/Screen/create_room.dart';
import 'package:draw_and_guess_promax/Screen/find_room.dart';
import 'package:draw_and_guess_promax/Screen/how_to_play.dart';
import 'package:draw_and_guess_promax/Screen/more_drawer.dart';
import 'package:draw_and_guess_promax/Widget/button.dart';
import 'package:draw_and_guess_promax/firebase.dart';
import 'package:flutter/material.dart';

Random random = Random();

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Khai báo một TextEditingController để lưu giữ nội dung của trường nhập văn bản
  final TextEditingController _textEditingController = TextEditingController();
  var _avaterIndex = random.nextInt(13);

  void _onMoreClick(context) {
    // Xử lý khi nút more được nhấn
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const MoreDrawer()));
  }

  void _onInformationClick(context) {
    // Xử lý khi nút information được nhấn
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const HowToPlay()));
  }

  void _findRoomClick(context) async {
    String name = _textEditingController.text;
    if (name == '') return;

    print('Tên: $name');
    print('Avatar index: $_avaterIndex');

    // Tạo tham chiếu đến mục users trên firebase
    final usersRef = database.child('/users/$name');
    await usersRef.update({'avatarIndex': _avaterIndex});

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const FindRoom()));
  }

  void _createRoomClick(context) async {
    String name = _textEditingController.text;
    if (name == '') return;

    print('Tên: $name');
    print('Avatar index: $_avaterIndex');

    // Tạo tham chiếu đến mục users trên firebase
    final usersRef = database.child('/users/$name');
    await usersRef.update({'avatarIndex': _avaterIndex});

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => CreateRoom()));
  }

  void _pickAvatar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Chọn Avatar',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          )),
          content: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Số cột trong lưới
                crossAxisSpacing: 8.0, // Khoảng cách giữa các cột
                mainAxisSpacing: 8.0, // Khoảng cách giữa các hàng
              ),
              itemCount: 13, // Số lượng avatar
              itemBuilder: (BuildContext context, int index) {
                // Tạo một avatar từ index
                return GestureDetector(
                  onTap: () {
                    // Xử lý khi người dùng chọn một avatar
                    setState(() {
                      _avaterIndex = index;
                    });
                    Navigator.of(context).pop(); // Đóng hộp thoại sau khi chọn
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/avatars/avatar$index.png'),
                  ),
                );
              },
            ),
          ),
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
          // Logo
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
          // App bar
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _onMoreClick(context);
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
                    _onInformationClick(context);
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
          // Nơi nhập thông tin
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
                  Container(
                    width: 123.20,
                    height: 123.20,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/avatars/avatar$_avaterIndex.png'),
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
                                _pickAvatar(context);
                              },
                              padding: const EdgeInsets.all(0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Trường nhập tên
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _textEditingController,
                      // Gán TextEditingController cho trường nhập văn bản
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
                ),
                const SizedBox(height: 20),
                Button(
                  onClick: _createRoomClick,
                  imageAsset: 'assets/images/plus.png',
                  title: 'Tạo phòng',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
