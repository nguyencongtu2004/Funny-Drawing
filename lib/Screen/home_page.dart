import 'package:draw_and_guess_promax/Screen/information.dart';
import 'package:draw_and_guess_promax/Screen/more_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Khai báo một TextEditingController để lưu giữ nội dung của trường nhập văn bản
  final TextEditingController _textEditingController = TextEditingController();

  // Hàm để in tên ra console
  void _printName() {
    String name = _textEditingController.text;
    print('Tên: $name');
  }

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
          ElevatedButton(
            onPressed:
                _printName, // Gọi hàm để in tên ra console khi nút được nhấn
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(170, 60),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              shadowColor: const Color.fromARGB(0, 0, 0, 0),
              surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.play_arrow_rounded),
                const SizedBox(width: 5),
                Text(
                  'Bắt đầu',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
