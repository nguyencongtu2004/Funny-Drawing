import 'package:flutter/material.dart';

class MoreDrawer extends StatelessWidget {
  const MoreDrawer({super.key});

  final buttonSize = const Size(100, 100);

  void _onCloseClick(context) {
    // Xử lý khi nút Close được nhấn
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF00C4A0), Color(0xFFD05700)])),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _onCloseClick(context);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(90, 90),
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  shadowColor: const Color.fromARGB(0, 0, 0, 0),
                  surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                ),
                child: Image.asset('assets/images/close.png'),
              ),
            ],
          ),
          const SizedBox(height: 100),
          TextButton(
              onPressed: () {},
              child: Text(
                'TRANG CHỦ',
                style: Theme.of(context).textTheme.titleLarge,
              )),
          const SizedBox(height: 5),
          TextButton(
              onPressed: () {},
              child: Text(
                'BẠN BÈ',
                style: Theme.of(context).textTheme.titleLarge,
              )),
          const SizedBox(height: 5),
          TextButton(
              onPressed: () {},
              child: Text(
                'LIÊN HỆ',
                style: Theme.of(context).textTheme.titleLarge,
              )),
          const SizedBox(height: 5),
          TextButton(
              onPressed: () {},
              child: Text(
                'GÓP Ý',
                style: Theme.of(context).textTheme.titleLarge,
              )),
          const SizedBox(height: 200),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: buttonSize,
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  shadowColor: const Color.fromARGB(0, 0, 0, 0),
                  surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                ),
                child: Image.asset('assets/images/facebook.png'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: buttonSize,
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  shadowColor: const Color.fromARGB(0, 0, 0, 0),
                  surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                ),
                child: Image.asset('assets/images/youtube.png'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: buttonSize,
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  shadowColor: const Color.fromARGB(0, 0, 0, 0),
                  surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                ),
                child: Image.asset('assets/images/instagram.png'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
