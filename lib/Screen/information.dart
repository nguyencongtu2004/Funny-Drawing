import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  const Information({super.key});

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
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Text(
            'CÁCH CHƠI',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Mỗi lượt sẽ có một người vẽ, và các người chơi còn lại phải đoán chính xác từ đó.\n\nNgười vẽ không được phép sử dụng các chữ cái, số hoặc hình ảnh thực tế trong bức tranh của mình.\n\nNgười vẽ chỉ được phép sử dụng các công cụ vẽ được cung cấp trong ứng dụng.\n\nNgười nào đoán đúng nhiều nhất và được nhiều người đoán đúng nhất bức tranh mình vẽ nhiều nhất thì được điểm càng cao.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _onCloseClick(context);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(130, 130), // Chỉnh kích thước nhỏ lại để tránh overflow, nếu muốn kích thước cũ thì để SingleChildScrollView
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              shadowColor: const Color.fromARGB(0, 0, 0, 0),
              surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
            ),
            child: Image.asset('assets/images/ok.png'),
          ),
        ],
      ),
    );
  }
}
