import 'package:draw_and_guess_promax/Screen/waiting_room.dart';
import 'package:draw_and_guess_promax/Widget/button.dart';
import 'package:draw_and_guess_promax/firebase.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:draw_and_guess_promax/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widget/room_to_play.dart';
import '../model/user.dart';

class FindRoom extends ConsumerStatefulWidget {
  const FindRoom({super.key});

  @override
  ConsumerState<FindRoom> createState() => _FindRoomState();
}

class _FindRoomState extends ConsumerState<FindRoom> {
  final selecting = ValueNotifier<String>('none');
  final password = ValueNotifier<String>('');
  final TextEditingController _idController = TextEditingController();
  String dropdownValue = 'Tất cả';

  var rooms = <Room>[];
  late List<Room> filteredRoom = [];

  @override
  void initState() {
    super.initState();
    database.child('/rooms').onValue.listen((event) {
      // Quan trọng
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      setState(() {
        // Xóa các phòng không tồn tại trong cơ sở dữ liệu Firebase khỏi danh sách rooms
        rooms = []; // TODO: không cập nhật khi phòng bị xóa

        // Cập nhật lại các phòng còn tồn tại trong cơ sở dữ liệu Firebase
        for (final room in data.entries) {
          final nextRoom = Room(
            roomId: room.key,
            roomOwner: room.value['roomOwner'],
            mode: room.value['mode'],
            curPlayer: room.value['curPlayer'],
            maxPlayer: room.value['maxPlayer'],
            isPrivate: room.value['isPrivate'],
            password: room.value['password'],
          );
          rooms.add(nextRoom);
        }
        filteredRoom = List.from(rooms);
      });
    });
  }

  Future<void> _onStartClick(BuildContext context, WidgetRef ref) async {
    print(selecting.value);
    print(password.value);
    final selectedRoom =
        rooms.firstWhere((room) => room.roomId == selecting.value);
    print('Password của phòng: ${selectedRoom.password}');
    if (selectedRoom.isPrivate && password.value != selectedRoom.password) {
      print('Sai mật khẩu');

      // Hiển thị thông báo khi nhập sai mật khẩu
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai mật khẩu!'),
        ),
      );
    } else {
      print('Đúng mật khẩu');

      // Cập nhật thông tin người chơi trong phòng
      final User player = ref.read(userProvider);

      final playersInRoomRef =
          database.child('/players_in_room/${selectedRoom.roomId}');
      await playersInRoomRef.update({
        player.id!: {
          'name': player.name,
          'avatarIndex': player.avatarIndex,
        },
      });

      // Cập nhật thông tin phòng
      final roomsRef = database.child('/rooms/${selectedRoom.roomId}');
      await roomsRef.update({
        'curPlayer': selectedRoom.curPlayer + 1,
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => WaitingRoom(
                selectedRoom: selectedRoom,
                isGuest: true,
              )));
    }
  }

  void _onFilterRoom() {
    final roomId = _idController.text;
    final filter = dropdownValue;
    print(roomId);
    print(filter);

    setState(() {
      if (roomId.isEmpty && filter == 'Tất cả') {
        filteredRoom = rooms;
      } else if (roomId.isEmpty && filter != 'Tất cả') {
        filteredRoom = rooms.where((room) => room.mode == filter).toList();
      } else if (roomId.isNotEmpty && filter == 'Tất cả') {
        filteredRoom =
            rooms.where((room) => room.roomId.contains(roomId)).toList();
      } else {
        filteredRoom = rooms
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
                    'Tìm phòng',
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
        // Thanh lọc phòng
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 35,
              child: Row(
                children: [
                  // Ô tìm id phòng
                  Expanded(
                    flex: 4,
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
                  Expanded(
                    flex: 6,
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
        ),
        // Danh sách các phòng
        if (filteredRoom.isEmpty)
          Center(
            child: Text(
              'Hiện không có phòng nào\nHãy tạo phòng mới!',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
        else
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
                    child: RoomToPlay(
                      mode: filteredRoom[index].mode,
                      curPlayer: filteredRoom[index].curPlayer,
                      maxPlayer: filteredRoom[index].maxPlayer,
                      roomId: filteredRoom[index].roomId,
                      isPrivate: filteredRoom[index].isPrivate,
                      selecting: selecting,
                      password: password,
                    ),
                  ),
                );
              },
            ),
          ),

        // Nút
        if (filteredRoom.isNotEmpty)
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 180 / 2,
            child: Row(
              children: [
                Button(
                  onClick: (ctx) {
                    _onStartClick(ctx, ref);
                  },
                  title: 'Vào phòng',
                  imageAsset: 'assets/images/play.png',
                  color: const Color(0xFFC45F00),
                )
              ],
            ),
          ),
      ]),
    );
  }
}
