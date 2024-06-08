import 'dart:async';
import 'dart:math';

import 'package:draw_and_guess_promax/Widget/ChatWidget.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/Widget/chat_list.dart';
import 'package:draw_and_guess_promax/Widget/normal_mode_status.dart';
import 'package:draw_and_guess_promax/data/word_to_guess.dart';
import 'package:draw_and_guess_promax/model/player_normal_mode.dart';
import 'package:draw_and_guess_promax/model/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';
import '../provider/chat_provider.dart';
import '../provider/user_provider.dart';

class NormalModeRoom extends ConsumerStatefulWidget {
  const NormalModeRoom({super.key, required this.selectedRoom});

  final Room selectedRoom;

  @override
  ConsumerState<NormalModeRoom> createState() => _NormalModeRoomState();
}

class _NormalModeRoomState extends ConsumerState<NormalModeRoom> {
  String _wordToDraw = '';
  late String wordToGuess;
  late String hint;
  late List<Map<String, dynamic>> chat = [];
  late DatabaseReference _roomRef;
  late DatabaseReference _playersInRoomRef;
  late DatabaseReference _chatRef;
  late DatabaseReference _drawingRef;
  late DatabaseReference _normalModeDataRef;
  late final List<PlayerInNormalMode> _playersInRoom = [];
  late List<String> _playersInRoomId = [];
  bool? _isMyTurn;
  int currentPlayerTurnIndex = 0;
  var _currentTurn = '';

  var isMyTurn = false;
  var _timeLeft = -1;
  var _pointLeft = 0;

  final _scrollController = ScrollController();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _roomRef = database.child('/rooms/${widget.selectedRoom.roomId}');
    _playersInRoomRef =
        database.child('/players_in_room/${widget.selectedRoom.roomId}');
    _drawingRef = database.child('/draw/${widget.selectedRoom.roomId}');
    _chatRef = database.child('/chat/${widget.selectedRoom.roomId}');
    _normalModeDataRef =
        database.child('/normal_mode_data/${widget.selectedRoom.roomId}');

    // Lắng nghe sự kiện thoát phòng
    _roomRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        // Room has been deleted
        if (widget.selectedRoom.roomOwner != ref.read(userProvider).id) {
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
        _playersInRoom.add(PlayerInNormalMode(
          id: player.key,
          name: player.value['name'],
          avatarIndex: player.value['avatarIndex'],
          point: player.value['point'],
          isCorrect: player.value['isCorrect'],
        ));
      }

      _playersInRoom.sort((a, b) => b.point.compareTo(a.point));
      _playersInRoomId.clear();
      _playersInRoomId = _playersInRoom.map((player) => player.id!).toList();
    });

    // Lấy thông tin từ chat
    _chatRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );

      final newChat = data.entries.map((e) {
        return {
          "id": e.value['id'],
          "userName": e.value['userName'],
          "message": e.value['message'],
          "timestamp": e.value['timestamp'],
        };
      }).toList();

      ref.read(chatProvider.notifier).updateChat(newChat);

      // đảm bảo rằng việc cuộn chỉ xảy ra sau khi giao diện đã được cập nhật hoàn tất.
      // Trùng với hàm _scrollToBottom()
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });

    // Lấy thông tin từ cần vẽ và lượt chơi
    _normalModeDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );

      wordToGuess = data['wordToDraw'];
      /*hint = allWords
          .firstWhere((element) => element.keys.first == wordToGuess)
          .values
          .first
          .first;*/
      hint = '';
      setState(() {
        _wordToDraw = data['wordToDraw'] as String;
      });
      final turn = data['turn'] as String;
      final userGuessed = data['userGuessed'] as String?;
      final timeLeft = data['timeLeft'] as int;
      final pointLeft = data['point'] as int;
      setState(() {
        _timeLeft = timeLeft;
        _pointLeft = pointLeft;
      });

      // Lấy tên người chơi hiện tại đang vẽ
      _currentTurn =
          _playersInRoom.firstWhere((player) => player.id == turn).name;

      // Cập nhật thời gian còn lại (chỉ chủ phòng mới được cập nhật trên Firebase)
      _startTimer();

      // Lấy vị trí của người chơi hiện tại
      currentPlayerTurnIndex = _playersInRoomId.indexOf(turn);
      setState(() {
        if (turn == ref.read(userProvider).id) {
          isMyTurn = true;
        } else {
          isMyTurn = false;
        }
      });

      // Chủ phòng cập nhật lượt chơi khi có người đoán đúng từ hoặc hết giờ
      if (((_pointLeft ==
                  (max(10, _playersInRoom.length) -
                      _playersInRoom.length +
                      1)) ||
              timeLeft == 0) &&
          ref.read(userProvider).id == widget.selectedRoom.roomOwner) {
        currentPlayerTurnIndex =
            (currentPlayerTurnIndex + 1) % _playersInRoomId.length;
        _normalModeDataRef.update({
          'userGuessed': null,
          'turn': _playersInRoomId[currentPlayerTurnIndex],
          'wordToDraw': pickRandomWordToGuess(),
          'timeLeft': 60,
          'point': (max(10, _playersInRoom.length)),
        });
        for (var player in _playersInRoom) {
          _playersInRoomRef.update({
            player.id!: {
              'name': player.name,
              'avatarIndex': player.avatarIndex,
              'point': player.point,
              'isCorrect': false,
            }
          });
        }
        ref.read(chatProvider.notifier).addMessage(ref.read(userProvider).id!,
            'Đáp án là: $wordToGuess', 'Đáp án', widget.selectedRoom.roomId);

        // Xóa bảng vẽ
        _drawingRef.update({
          'Color': '[]',
          'Offset': '[]',
        });

        // Ket thuc game
        // if(_endGame) {
        //   _normalModeDataRef.remove();
        //   Navigator.of(context).pop();
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (ctx) => Ranking(selectedRoom: widget.selectedRoom)));
        // }
      }
    });

    // Kiểm tra lượt để hiển thị chat
    _normalModeDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      setState(() {
        _isMyTurn = data['turn'] == ref.read(userProvider).id;
        var player = ref.read(userProvider);
        var point = 0;
        for (var pl in _playersInRoom) {
          if (pl.id == player.id) {
            point = pl.point;
            break;
          }
        }
        if (_isMyTurn == true) {
          _playersInRoomRef.update({
            player.id!: {
              'name': player.name,
              'avatarIndex': player.avatarIndex,
              'point': point,
              'isCorrect': true,
            }
          });
        } else {
          _playersInRoomRef.update({
            player.id!: {
              'name': player.name,
              'avatarIndex': player.avatarIndex,
              'point': point,
              'isCorrect': false,
            }
          });
        }
      });
    });
  }

  void _startTimer() {
    if (widget.selectedRoom.roomOwner == ref.read(userProvider).id) {
      _timer?.cancel(); // Hủy Timer nếu đã tồn tại
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          _normalModeDataRef.update({'timeLeft': _timeLeft - 1});
        } else {
          timer.cancel(); // Hủy Timer khi thời gian kết thúc
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose
    super.dispose();
  }

  void _showChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF00C4A1),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.8,
          child: Chat(
            roomId: widget.selectedRoom.roomId,
            height: MediaQuery.of(ctx).size.height,
            width: MediaQuery.of(ctx).size.width,
          ),
        );
      },
    );
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

    if (widget.selectedRoom.roomOwner == userId) {
      await _roomRef.remove();
      await _playersInRoomRef.remove();
      await _chatRef.remove();
      await _drawingRef.remove();
      await _normalModeDataRef.remove();
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

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatProvider);

    // Chờ dữ liệu từ Firebase
    if (_isMyTurn == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                'Đang tải...',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      );
    } else {
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
            Navigator.pop(context);
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
                          'Thường',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 45,
                          width: 45,
                          child: IconButton(
                            onPressed: _showChat,
                            icon: Image.asset('assets/images/chat.png'),
                            iconSize: 45,
                          ),
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
                child: Drawing(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  selectedRoom: widget.selectedRoom,
                ),
              ),
            ),
            // Hint
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: NormalModeStatus(
                      status: isMyTurn
                          ? 'Hãy vẽ: $wordToGuess '
                          : 'Đoán xem đây là gì?',
                      timeLeft: _timeLeft),
                ),
              ),
            ),
            // Chat
            if (_isMyTurn == false) ...[
              // Bình phong
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: const Color(0xFF00C4A1),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cho $_currentTurn biết suy nghĩ của bạn',
                            hintStyle: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Lớp đè lên, khi ấn thì mở chat và bàn phím
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    _showChat();
                  },
                  child: Container(
                    height: 95,
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
            Positioned(
                bottom: 95,
                left: 0,
                right: 0,
                child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    height: 100,
                    decoration: const BoxDecoration(
                        color: Color(0xFF00C4A1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )),
                    child: ChatList(
                        scrollController: _scrollController,
                        chatMessages: chatMessages))),
          ]),
        ),
      );
    }
  }
}
