import 'dart:async';
import 'dart:convert';

import 'package:draw_and_guess_promax/Widget/loading.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widget/button.dart';
import '../firebase.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';
import 'home_page.dart';
import 'knock_off_mode.dart';

class KnockoffModeAlbum extends ConsumerStatefulWidget {
  const KnockoffModeAlbum({
    super.key,
    required this.selectedRoom,
  });

  final Room selectedRoom;

  @override
  createState() => _KnockoffModeAlbumState();
}

class _KnockoffModeAlbumState extends ConsumerState<KnockoffModeAlbum> {
  late final _userId;
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  late DatabaseReference _chatRef;
  late DatabaseReference _drawingRef;
  late DatabaseReference _knockoffModeDataRef;
  late final List<User> _playersInRoom = [];
  late List<String> _playersInRoomId = [];
  late DatabaseReference _myDataRef;
  late DatabaseReference _myAlbumRef;
  List<List<Map<String, String>>> picturesOfUsers = [];
  var _showingIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _userId = ref.read(userProvider).id;
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _drawingRef = database.child('/draw/${widget.selectedRoom.roomId}');
    _chatRef = database.child('/chat/${widget.selectedRoom.roomId}');
    _knockoffModeDataRef =
        database.child('/knockoff_mode_data/${widget.selectedRoom.roomId}');
    _myDataRef = _knockoffModeDataRef.child('/$_userId');
    _myAlbumRef = _knockoffModeDataRef.child('/$_userId/album');

    // Lấy thông tin người chơi và tranh trong phòng
    _playersInRoomRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      _playersInRoom.clear();
      for (final player in data.entries) {
        _playersInRoom.add(User(
          id: player.key,
          name: player.value['name'],
          avatarIndex: player.value['avatarIndex'],
        ));
      }
      _playersInRoomId.clear();
      _playersInRoomId = _playersInRoom.map((player) => player.id!).toList();

      _getPictures();
    });

    //
    _knockoffModeDataRef.onValue.listen((event) async {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );

      var albumShowingIndex = data['albumShowingIndex'];
      if (albumShowingIndex == -1) {
        // Nếu chưa có thông tin albumShowingIndex thì set mặc định là 0
        // Hoặc làm gì đó khác...
        albumShowingIndex = 0;
      }

      // có thể chơi lại ở đây
      if (albumShowingIndex >= _playersInRoom.length) {
        _playAgain();
      } else {
        setState(() {
          _showingIndex = albumShowingIndex;
        });
      }
    });
  }

  Future<void> _getPictures() async {
    for (final id in _playersInRoomId) {
      List<Map<String, String>> pictures = [];
      DatabaseReference albumRef = database
          .child('/knockoff_mode_data/${widget.selectedRoom.roomId}/$id/album');
      DataSnapshot snapshot = await albumRef.get();

      final album = Map<String, dynamic>.from(snapshot.value as Map);
      final firstPlayerIndex =
          _playersInRoom.indexWhere((player) => player.id == id);
      var bias = 0;

      for (final picture in album.entries) {
        final color = picture.value['Color'] as String;
        final offset = picture.value['Offset'] as String;

        final player =
            _playersInRoom[(firstPlayerIndex + bias) % _playersInRoom.length];

        pictures.add({
          'avatarIndex': player.avatarIndex.toString(),
          'name': player.name,
          'Color': color,
          'Offset': offset,
        });
        bias++;
      }
      setState(() {
        picturesOfUsers.add(pictures);
      });
    }
    print('========================================');
    print('Pictures: ${picturesOfUsers[_showingIndex]}');
    print('========================================');
  }

  Future<void> _playOutRoom(WidgetRef ref) async {
    final userId = ref.read(userProvider).id;
    if (userId == null) return;

    if (widget.selectedRoom.roomOwner == userId) {
      await _roomRef.remove();
      await _playersInRoomRef.remove();
      await _knockoffModeDataRef.remove();
    } else {
      final playerRef = database
          .child('/players_in_room/${widget.selectedRoom.roomId}/$userId');
      await playerRef.remove();

      final currentPlayerCount =
          (await _roomRef.child('curPlayer').get()).value as int;
      if (currentPlayerCount > 0) {
        await _roomRef.update({
          'curPlayer': currentPlayerCount - 1,
        });
      }
    }
  }

  late Completer<bool> _completer;

  Future<bool> _showDialog(String title, String content,
      {bool isKicked = false}) async {
    _completer = Completer<bool>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          backgroundColor: const Color(0xFF00C4A0),
          actions: [
            if (!isKicked)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _completer.complete(false); // Hoàn thành với giá trị true
                },
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completer.complete(true); // Hoàn thành với giá trị true
              },
              child: Text(
                isKicked ? 'OK' : 'Thoát',
                style: TextStyle(
                  color: isKicked ? Colors.black : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    return _completer.future; // Trả về Future từ Completer
  }

  // Chủ phòng mới gọi được hàm này
  Future<void> _playAgain() async {
    // Reset the state in the database
    if (ref.read(userProvider).id == widget.selectedRoom.roomOwner) {
      await _knockoffModeDataRef.update({
        'turn': 1,
        'playerDone': 0,
        'timeLeftMode': 90,
        'albumShowingIndex': -1,
        // Add more fields if necessary
      });
      if (widget.selectedRoom.roomOwner == ref.read(userProvider).id) {
        print('============================================================');
        print('Chủ phòng đã cập nhật lại trạng thái phòng');
        print('============================================================');
      }
    }
    await _myDataRef.remove();

    // Clear the local state
    setState(() {
      picturesOfUsers.clear();
      _showingIndex = 0;
    });

    // Navigate back to HomePage and then to a new KnockoffModeAlbum instance
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => const HomePage(),
      ),
      (route) => false,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => KnockoffMode(
          selectedRoom: widget.selectedRoom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double widthOfPicture = 250;
    const double heightOfPicture = 400;
    if (picturesOfUsers.isEmpty) {
      return const Loading(
        text: 'Đang tải album...',
      );
    }
    if (_showingIndex >= _playersInRoom.length) {
      return const Loading(
        text: 'Đang chờ chơi lại...',
      );
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final isQuit = (ref.read(userProvider).id ==
                widget.selectedRoom.roomOwner)
            ? await _showDialog('Cảnh báo',
                'Nếu bạn thoát, phòng sẽ bị xóa và tất cả người chơi khác cũng sẽ bị đuổi ra khỏi phòng. Bạn có chắc chắn muốn thoát không?')
            : await _showDialog(
                'Cảnh báo', 'Bạn có chắc chắn muốn thoát khỏi phòng không?');

        if (context.mounted && isQuit) {
          _playOutRoom(ref);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const HomePage()),
            (route) => false,
          );
        }
      },
      child: Stack(
        children: [
          // nền
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE5E5E5),
          ),
          // Các bức tranh và nút
          Positioned(
              top: 100,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: const Color(0xFF00C4A1),
                // Phải có width và height cố định để CustomPaint biết kích thước cần vẽ
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width + 1,
                child: ListView.builder(
                  itemCount: picturesOfUsers[_showingIndex].length,
                  itemBuilder: (context, index) {
                    final name = picturesOfUsers[_showingIndex][index]['name']!;
                    final avatarIndex =
                        picturesOfUsers[_showingIndex][index]['avatarIndex']!;
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index != 0) ...[
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/avatars/avatar$avatarIndex.png'), // Sử dụng AssetImage như là ImageProvider
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: index == 0
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      color: Colors.white,
                                      width: widthOfPicture,
                                      height: heightOfPicture,
                                      child: picturesOfUsers[_showingIndex]
                                              .isNotEmpty
                                          ? CustomPaint(
                                              painter: PaintCanvas(
                                                points: scaleOffset(
                                                    decodeOffsetList(
                                                        picturesOfUsers[
                                                                _showingIndex]
                                                            [index]['Offset']!),
                                                    scale: 0.5),
                                                paints: decodePaintList(
                                                    picturesOfUsers[
                                                            _showingIndex]
                                                        [index]['Color']!),
                                              ),
                                              size: const Size(widthOfPicture,
                                                  heightOfPicture),
                                            )
                                          : Container(
                                              width: widthOfPicture,
                                              height: heightOfPicture,
                                              color: Colors
                                                  .transparent, // Placeholder while loading
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index == 0) ...[
                              const SizedBox(width: 5),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/avatars/avatar$avatarIndex.png'), // Sử dụng AssetImage như là ImageProvider
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (index ==
                            picturesOfUsers[_showingIndex].length - 1) ...[
                          const SizedBox(height: 25),
                          if (_userId == widget.selectedRoom.roomOwner)
                            Column(
                              children: [
                                Button(
                                  onClick: (ctx) {
                                    setState(() async {
                                      // Chưa xem hết thì chuyển qua bức tiếp theo
                                      await _knockoffModeDataRef.update({
                                        'albumShowingIndex': _showingIndex + 1,
                                      });
                                    });
                                  },
                                  title: _showingIndex + 1 !=
                                          picturesOfUsers.length
                                      ? 'Tiếp tục'
                                      : 'Chơi lại',
                                  width: 150,
                                  borderRadius: 25,
                                ),
                                const SizedBox(height: 10),
                                if (_showingIndex + 1 == picturesOfUsers.length)
                                  Text('Xem hết rồi, chơi lại nhé?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                              ],
                            )
                          else
                            Text(
                              _showingIndex + 1 != picturesOfUsers.length
                                  ? 'Chờ chủ phòng tiếp tục...'
                                  : 'Xem hết rồi,\nhãy nhắc chủ phòng chơi lại nhé!',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 160),
                        ],
                      ],
                    );
                  },
                ),
              )),
          // App bar
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: Color(0xFF00C4A1)),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Album của ${picturesOfUsers[_showingIndex].first['name']}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm decode chuỗi JSON thành List<Paint>
  List<Paint> decodePaintList(String jsonStr) {
    List<Map<String, dynamic>> decodedList =
        List<Map<String, dynamic>>.from(json.decode(jsonStr));
    return decodedList.map((paintMap) {
      Paint paint = Paint()
        ..color = Color(paintMap['color'])
        ..strokeWidth = paintMap['strokeWidth']
        ..strokeCap = StrokeCap.values.firstWhere(
          (e) => e.toString() == 'StrokeCap.' + paintMap['strokeCap'],
          orElse: () => StrokeCap.butt, // Default value if not found
        );
      // Add other properties if needed
      return paint;
    }).toList();
  }

  // Hàm decode chuỗi JSON thành List<List<Offset>>
  List<List<Offset>> decodeOffsetList(String jsonStr) {
    List<List<Offset>> offsetList = [];

    if (jsonStr.isNotEmpty) {
      // Decode the JSON string
      List<dynamic> decodedList = json.decode(jsonStr);

      // Process each inner list
      for (var innerList in decodedList) {
        if (innerList is List) {
          List<Offset> tempList = [];
          for (int i = 0; i < innerList.length; i += 2) {
            tempList.add(
                Offset(innerList[i] as double, innerList[i + 1] as double));
          }
          offsetList.add(tempList);
        }
      }
    }

    return offsetList;
  }

  // Hàm thu nhỏ offset
  List<List<Offset>> scaleOffset(List<List<Offset>> offsetList,
      {double scale = 1.0}) {
    return offsetList.map((offsets) {
      return offsets.map((offset) {
        return Offset(offset.dx * scale, offset.dy * scale);
      }).toList();
    }).toList();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose
    super.dispose();
  }
}

class PaintCanvas extends CustomPainter {
  final List<List<Offset>> points;
  final List<Offset> tmp;
  final List<Paint> paints;

  PaintCanvas({
    required this.points,
    this.tmp = const [],
    required this.paints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < points[i].length - 1; j++) {
        if (points[i][j] != const Offset(-1, -1) &&
            points[i][j + 1] != const Offset(-1, -1)) {
          canvas.drawLine(points[i][j], points[i][j + 1], paints[i]);
        }
      }
    }

    if (paints.isNotEmpty) {
      Paint tmpPaint = paints.last;

      for (int j = 0; j < tmp.length - 1; j++) {
        if (tmp[j] != const Offset(-1, -1) &&
            tmp[j + 1] != const Offset(-1, -1)) {
          canvas.drawLine(tmp[j], tmp[j + 1], tmpPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(PaintCanvas oldDelegate) => true;
}
