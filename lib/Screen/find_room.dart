import 'package:draw_and_guess_promax/Widget/button.dart';
import 'package:draw_and_guess_promax/Widget/play_mode.dart';
import 'package:draw_and_guess_promax/data/room_data.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:flutter/material.dart';

class FindRoom extends StatefulWidget {
  const FindRoom({super.key});

  @override
  State<FindRoom> createState() => _FindRoomState();
}

class _FindRoomState extends State<FindRoom> {
  final selecting = ValueNotifier<String>('none');
  final TextEditingController _idController = TextEditingController();
  String dropdownValue = 'Tất cả';
  List<Room> filteredRoom = availableRoom;

  void _onStartClick(BuildContext context) {
    print(selecting.value);
  }

  void _onFilterRoom() {
    final roomId = _idController.text;
    final filter = dropdownValue;
    print(roomId);
    print(filter);

    setState(() {
      if (roomId.isEmpty && filter == 'Tất cả') {
        filteredRoom = availableRoom;
      } else if (roomId.isEmpty && filter != 'Tất cả') {
        filteredRoom =
            availableRoom.where((room) => room.mode == filter).toList();
      } else if (roomId.isNotEmpty && filter == 'Tất cả') {
        filteredRoom = availableRoom
            .where((room) => room.roomId.contains(roomId))
            .toList();
      } else {
        filteredRoom = availableRoom
            .where(
                (room) => room.roomId.contains(roomId) && room.mode == filter)
            .toList();
      }
    });
  }

  // Hàm xây dựng mỗi item trong dropdown menu
  Widget _buildDropdownMenuItem(String value) {
    return InkWell(
      onTap: () {
        setState(() {
          dropdownValue = value;
        });
        //_onCompleteFilter(value);
        _onFilterRoom();
        Navigator.pop(context); // Đóng dropdown menu khi chọn một item
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black),
        ),
      ),
    );
  }

  // Hàm hiển thị dropdown menu
  void _showDropdownMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdownMenuItem('Tất cả'),
                _buildDropdownMenuItem('Thường'),
                _buildDropdownMenuItem('Tam sao thất bản'),
                _buildDropdownMenuItem('Tuyệt tác'),
              ],
            ),
          ),
        );
      },
    );
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
        Positioned(
          top: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Ô tìm id phòng
                SizedBox(
                  width: 140,
                  height: 35,
                  child: TextField(
                    controller: _idController,
                    // Gán TextEditingController cho trường nhập văn bản
                    decoration: InputDecoration(
                      hintText: 'Id phòng',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // Điều chỉnh độ cong của viền
                        borderSide: const BorderSide(
                            color: Colors.transparent), // Màu của viền
                      ),
                      filled: true,
                      // Đánh dấu để hiển thị nền
                      fillColor: Colors.white,
                      // Màu của nền
                      prefixIcon: SizedBox(
                        height: 24, // Điều chỉnh chiều cao của icon
                        width: 24, // Điều chỉnh chiều rộng của icon
                        child: Image.asset(
                            'assets/images/search.png'), // Thêm biểu tượng bên trái
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    onChanged: (roomId) {
                      //_onChangeRoomId(roomId);
                      _onFilterRoom();
                    },
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                // Ô lọc chế độ
                SizedBox(
                  width: 190,
                  height: 35,
                  child: InkWell(
                    onTap: () {
                      _showDropdownMenu(context);
                    },
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: dropdownValue,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // Điều chỉnh độ cong của viền
                          borderSide: const BorderSide(
                              color: Colors.transparent), // Màu của viền
                        ),
                        filled: true,
                        // Đánh dấu để hiển thị nền
                        fillColor: Colors.white,
                        // Màu của nền
                        prefixIcon: SizedBox(
                          height: 24, // Điều chỉnh chiều cao của icon
                          width: 24, // Điều chỉnh chiều rộng của icon
                          child: Image.asset(
                              'assets/images/filter.png'), // Thêm biểu tượng bên trái
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Danh sách các phòng
        Padding(
          padding: const EdgeInsets.only(top: 170),
          child: ListView.builder(
            key: ValueKey(filteredRoom),
            padding: EdgeInsets.zero,
            itemCount: filteredRoom.length,
            itemBuilder: (ctx, index) {
              final isLastItem = index == filteredRoom.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                    left: 8, right: 8, bottom: isLastItem ? 120 : 8),
                child: InkWell(
                  onTap: () {
                    selecting.value = filteredRoom[index].roomId;
                  },
                  child: PlayMode(
                    mode: filteredRoom[index].mode,
                    curPlayer: filteredRoom[index].curPlayer,
                    maxPlayer: filteredRoom[index].maxPlayer,
                    roomId: filteredRoom[index].roomId,
                    isPrivate: filteredRoom[index].isPrivate,
                    selecting: selecting,
                  ),
                ),
              );
            },
          ),
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
