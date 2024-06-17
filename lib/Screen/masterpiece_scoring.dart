import 'dart:async';
import 'dart:convert';

import 'package:draw_and_guess_promax/Widget/button.dart';
import 'package:draw_and_guess_promax/Widget/masterpiece_mark_status.dart';
import 'package:draw_and_guess_promax/model/player_masterpiece_mode.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';
import '../provider/user_provider.dart';
import 'knock_off_mode_album.dart';

class MasterPieceScoring extends ConsumerStatefulWidget {
  const MasterPieceScoring({
    super.key,
    required this.selectedRoom,
  });

  final Room selectedRoom;

  @override
  createState() => _MasterPieceMarkState();
}

class _MasterPieceMarkState extends ConsumerState<MasterPieceScoring> {
  late String roomOwner = widget.selectedRoom.roomOwner!;
  late final List<PlayerInMasterPieceMode> _playersInRoom = [];
  late List<String> _playersInRoomId = [];
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  late DatabaseReference _playerInRoomIDRef;
  late DatabaseReference _masterpieceModeDataRef;
  late DatabaseReference _scoreRef;
  List<int> buttonStates = [1, 2, 3, 4, 5];
  var _selectedPoint = 0;

  List<Map<String, dynamic>> pictures = [];
  int _showingIndex = 0;

  var _timeLeft = -1;
  late int _curPlayer;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _masterpieceModeDataRef =
        database.child('/masterpiece_mode_data/${widget.selectedRoom.roomId}');
    _playerInRoomIDRef = database.child(
        '/players_in_room/${widget.selectedRoom.roomId}/${ref.read(userProvider).id}');
    _scoreRef = database.child(
        '/masterpiece_mode_data/${widget.selectedRoom.roomId}/score/${ref.read(userProvider).id}');

    // Cập nhật thời gian còn lại (chỉ chủ phòng mới được cập nhật trên Firebase)
    _startTimer();

    // Lắng nghe sự kiện thoát phòng TODO
    _roomRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>,
        );
        _curPlayer = data['curPlayer'] as int;
        roomOwner = data['roomOwner']!;
        // Room has been deleted
        if (roomOwner != ref.read(userProvider).id) {
          await _showDialog('Phòng đã bị xóa', 'Phòng đã bị xóa bởi chủ phòng',
              isKicked: true);
          Navigator.of(context).pop();
        }
      }
    });

    // Lấy thông tin người chơi trong phòng
    _playersInRoomRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      _playersInRoom.clear();
      for (final player in data.entries) {
        _playersInRoom.add(PlayerInMasterPieceMode(
          id: player.key,
          name: player.value['name'],
          avatarIndex: player.value['avatarIndex'],
          point: player.value['point'],
        ));
      }

      _playersInRoomId.clear();
      _playersInRoomId = _playersInRoom.map((player) => player.id!).toList();

      _getPictures();
    });

    // Lấy thông tin từ cần vẽ
    _masterpieceModeDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      setState(() {
        _showingIndex = data['showingIndex'] as int;
        _timeLeft = data['timeLeft'] as int;
      });
      if (_showingIndex >= _playersInRoomId.length) {
        _timer?.cancel();
        // todo: sang màn tổng kêt
        print('End game');
      }

      if (_timeLeft == 0) {
        // todo
        _masterpieceModeDataRef
            .child(
                '/score/${pictures.firstWhere((e) => e['Index'] == _showingIndex)['Id']}')
            .set({
          '${ref.read(userProvider).id}': _selectedPoint,
        });
        if (ref.read(userProvider).id == roomOwner) {
          _masterpieceModeDataRef.update({
            'showingIndex': _showingIndex + 1,
            'timeLeft': 15,
          });
        }
      }
    });
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
                  _completer.complete(false);
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
                _completer.complete(true);
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
    return _completer.future;
  }

  Future<void> _playOutRoom(WidgetRef ref) async {
    final userId = ref.read(userProvider).id;
    if (userId == null) return;

    final currentPlayerCount = _curPlayer;
    if (currentPlayerCount > 0) {
      // Nếu còn 2 người chơi thì xóa phòng
      if (currentPlayerCount <= 2) {
        _masterpieceModeDataRef.update({
          'noOneInRoom': true,
        });
      } else {
        // Nếu còn nhiều hơn 2 người chơi thì giảm số người chơi
        // todo
      }
    }

    // ??
    await _playerInRoomIDRef.remove();
    if (roomOwner == userId) {
      print("Chu phong");
      for (var cp in _playersInRoom) {
        if (cp.id != roomOwner) {
          _roomRef.update({
            'roomOwner': cp.id,
          });
          break;
        }
      }
    }
  }

  void _startTimer() {
    if (roomOwner == ref.read(userProvider).id) {
      _timer?.cancel(); // Hủy Timer nếu đã tồn tại
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          _masterpieceModeDataRef.update({'timeLeft': _timeLeft - 1});
        } else {
          timer.cancel(); // Hủy Timer khi thời gian kết thúc
        }
      });
    }
  }

  Future<void> _getPictures() async {
    var count = 0;
    for (var id in _playersInRoomId) {
      List<Map<String, String>> picture = [];
      final snapshot = await _masterpieceModeDataRef.child('/album/$id').get();
      final data = Map<String, String>.from(snapshot.value as Map);
      final color = data['Color'] as String;
      final offset = data['Offset'] as String;
      pictures.add({
        'Index': count,
        'Id': id,
        'Color': color,
        'Offset': offset,
      });
      count++;
    }
    print(pictures.length); // worked
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsetList = decodeOffsetList(pictures[_showingIndex]['Offset']!);
    final paintList = decodePaintList(pictures[_showingIndex]['Color']!);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final isQuit = (ref.read(userProvider).id == roomOwner)
            ? await _showDialog('Cảnh báo',
                'Nếu bạn thoát, phòng sẽ bị xóa và tất cả người chơi khác cũng sẽ bị đuổi ra khỏi phòng. Bạn có chắc chắn muốn thoát không?')
            : await _showDialog(
                'Cảnh báo', 'Bạn có chắc chắn muốn thoát khỏi phòng không?');

        if (context.mounted && isQuit) {
          _playOutRoom(ref);
          Navigator.of(context).pop();
        }
      },
      child: Stack(children: [
        // App bar
        Container(
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(color: Color(0xFF00C4A1)),
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
                        onPressed: () async {
                          if (ref.read(userProvider).id ==
                              widget.selectedRoom.roomOwner) {
                            final isQuit = await _showDialog('Cảnh báo',
                                'Nếu bạn thoát, phòng sẽ bị xóa và tất cả người chơi khác cũng sẽ bị đuổi ra khỏi phòng. Bạn có chắc chắn muốn thoát không?');
                            if (!isQuit) return;
                          } else {
                            final isQuit = await _showDialog('Cảnh báo',
                                'Bạn có chắc chắn muốn thoát khỏi phòng không?');
                            if (!isQuit) return;
                          }

                          await _playOutRoom(ref);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: Image.asset('assets/images/back.png'),
                        iconSize: 45,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tuyệt tác',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Drawing board
        Positioned(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              color: Colors.white,
              child: CustomPaint(
                painter: PaintCanvas(
                  points: offsetList,
                  paints: paintList,
                ),
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
              ),
            ),
          ),
        ),
        // status
        Positioned(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: MasterpieceMarkStatus(
                    timeLeft: _timeLeft,
                  )),
            ),
          ),
        ),
        // Chấm điểm
        if (ref.read(userProvider).id != pictures[_showingIndex]['Id'])
          Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final number in buttonStates)
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2 - 10,
                            child: Button(
                              title: '$number',
                              color: number == _selectedPoint
                                  ? const Color(0xFF00C4A0)
                                  : Colors.grey,
                              onClick: (ctx) {
                                setState(() {
                                  _selectedPoint = number;
                                });
                              },
                            ))
                    ],
                  ),
                ),
              ))
      ]),
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
}
