import 'package:draw_and_guess_promax/Screen/create_room.dart';
import 'package:draw_and_guess_promax/Screen/find_room.dart';
import 'package:draw_and_guess_promax/Screen/information.dart';
import 'package:draw_and_guess_promax/Screen/more_drawer.dart';
import 'package:draw_and_guess_promax/Widget/button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Khai báo một TextEditingController để lưu giữ nội dung của trường nhập văn bản
  final TextEditingController _textEditingController = TextEditingController();

  void _onMoreClick(context) {
    // Xử lý khi nút more được nhấn
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const MoreDrawer()));
  }

  void _onInformationClick(context) {
    // Xử lý khi nút information được nhấn
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const Information()));
  }

  void _findRoomClick(context) {
    String name = _textEditingController.text;
    print('Tên: $name');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const FindRoom()));
  }

  void _createRoomClick(context) {
    String name = _textEditingController.text;
    print('Tên: $name');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const CreateRoom()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF00C4A0), Color(0xFFD05700)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 35),
          Row(
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
          Container(
            width: 160,
            height: 120,
            child: Image.asset('assets/images/logo.png'),
          ),
          const SizedBox(height: 20),
          Container(
            width: 310,
            height: 250,
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFD6FFBE), Color(0xFFC29191)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Container(
                  width: 123.20,
                  height: 123.20,
                  decoration: const ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/avatar.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: CircleBorder(),
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
                            onPressed: () {},
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
                      hintText: 'Nhập thông tin',
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
          const SizedBox(height: 50),
          Column(
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
          )
        ],
      ),
    );
  }
}
