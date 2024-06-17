import 'dart:async';
import 'dart:math';

import 'package:draw_and_guess_promax/Screen/home_page.dart';
import 'package:draw_and_guess_promax/Screen/masterpiece_mark.dart';
import 'package:draw_and_guess_promax/Widget/ChatWidget.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/Widget/button.dart';
import 'package:draw_and_guess_promax/Widget/masterpiece_mark_status.dart';
import 'package:draw_and_guess_promax/Widget/masterpiece_mode_status.dart';
import 'package:draw_and_guess_promax/Widget/normal_mode_status.dart';
import 'package:draw_and_guess_promax/data/word_to_guess.dart';
import 'package:draw_and_guess_promax/model/player_masterpiece_mode.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';

class MasterPieceMark extends ConsumerStatefulWidget {
  const MasterPieceMark({super.key, required this.selectedRoom,});

  final Room selectedRoom;

  @override
  createState() => _MasterPieceMarkState();
}

class _MasterPieceMarkState extends ConsumerState<MasterPieceMark> {
  late String roomOwner = widget.selectedRoom.roomOwner!;
  String _wordToDraw = '';
  late final List<PlayerInMasterPieceMode> _playersInRoom = [];
  List<List<Map<String, String>>> pictures = [];
  late List<String> _playersInRoomId = [];
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  late DatabaseReference _playerInRoomIDRef;
  List<Map<String, String>> picturesOfUsers = [];
  late DatabaseReference _chatRef;
  late DatabaseReference _drawingRef;
  late DatabaseReference _masterpieceModeDataRef;
  late final  album;
  List<bool> buttonStates = [false, false, false, false, false];
  late int _pointSelect;

  int get pointSelect {
    return _pointSelect;
  }

  set pointSelect(int value) {
    if (value >= 1 && value <= 5) {
      _pointSelect = value;
    }
  }

  var _showingIndex = 0;
  var _timeLeft = -1;
  var _point = 0;
  var _curPlayer = 2;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _drawingRef = database.child('/draw/${widget.selectedRoom.roomId}');
    _chatRef = database.child('/chat/${widget.selectedRoom.roomId}');
    _masterpieceModeDataRef =
        database.child('/masterpiece_mode_data/${widget.selectedRoom.roomId}');
    _playerInRoomIDRef = database.child(
        '/players_in_room/${widget.selectedRoom.roomId}/${ref.read(userProvider).id}');

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
      Future.delayed(const Duration(milliseconds: 100), () {
        _animatePictures();
      });
    });

    // Lấy thông tin từ cần vẽ
    _masterpieceModeDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map
      );
      print(data);
      print(data['wordToDraw'].runtimeType);
      print(data['point'].runtimeType);
      print(data['timeLeft'].runtimeType);


      setState(() {
        _wordToDraw = data['wordToDraw'] as String;
      });
      final timeLeft = data['timeLeft'] as int;
      setState(() {
        _timeLeft = timeLeft;
      });


      // Cập nhật thời gian còn lại (chỉ chủ phòng mới được cập nhật trên Firebase)
      _startTimer();

      if (_timeLeft == 0) {

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
    print("So luong: " + currentPlayerCount.toString());
    if (currentPlayerCount > 0) {
      // Nếu còn 2 người chơi thì xóa phòng
      if (currentPlayerCount <= 2) {
        _masterpieceModeDataRef.update({
          'noOneInRoom': true,
        });
      } else {
        // Nếu còn nhiều hơn 2 người chơi thì giảm số người chơi
        _roomRef.update({
          'curPlayer': currentPlayerCount - 1,
        });
      }
    }
    await _playerInRoomIDRef.remove();
    if (roomOwner == userId) {
      print("Chu phong");
      for(var cp in _playersInRoom) {
        if(cp.id != roomOwner) {
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
      for (var id in _playersInRoomId){
        final snapshot = await _masterpieceModeDataRef.child('/album/$id').get();
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        print(data);

      }
  }

  void _animatePictures() {
    // Xóa tất cả các item hiện có
    final int itemCount = picturesOfUsers[_showingIndex].length;
    for (int i = itemCount - 1; i >= 0; i--) {
      _listKey.currentState!.removeItem(
        i,
            (context, animation) =>
            SizeTransition(
              sizeFactor: animation,
              child: Container(), // Một container rỗng để animate việc xóa
            ),
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final isQuit = (ref.read(userProvider).id ==
            roomOwner)
            ? await _showDialog('Cảnh báo',
            'Nếu bạn thoát, phòng sẽ bị xóa và tất cả người chơi khác cũng sẽ bị đuổi ra khỏi phòng. Bạn có chắc chắn muốn thoát không?')
            : await _showDialog(
            'Cảnh báo', 'Bạn có chắc chắn muốn thoát khỏi phòng không?');

        if (context.mounted && isQuit) {
          _playOutRoom(ref);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(children: [
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
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: MasterpieceMarkStatus(
                    timeLeft: _timeLeft,
                  )
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Positioned(
                child: Container(
                    width: 400,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < buttonStates.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 70,
                                  child: Button(
                                      color: buttonStates[i] ? Color(0xFF00C4A0) : Colors.grey,
                                      onClick: (ctx) {
                                        setState(() {
                                          _point = i + 1;
                                          for (var j = 0; j < buttonStates.length; j++) {
                                            buttonStates[j] = (j == i);
                                          }
                                        });
                                      },
                                      title: '${i + 1}',
                                  )
                                ),
                              )
                          ],
                        ),
                      )
                    )
                ),
              )

        ]),
      ),
    );
  }
}
