import 'package:draw_and_guess_promax/provider/chat_provider.dart';
import 'package:draw_and_guess_promax/provider/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';

class ChatArea extends ConsumerStatefulWidget {
  const ChatArea({
    super.key,
    required this.roomId,
    required this.width,
  });

  final String roomId;
  final double width;

  @override
  _ChatAreaState createState() => _ChatAreaState();
}

class _ChatAreaState extends ConsumerState<ChatArea> {
  //late List<Map<String, dynamic>> chat = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late DatabaseReference _chatRef;
  late DatabaseReference _normalModeDataRef;
  late DatabaseReference _roomRef;

  final ScrollController _scrollController = ScrollController();
  var wordToGuess = '';
  late String roomOwnerId;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Tự động focus vào TextField khi widget được xây dựng xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    _chatRef = database.child('/chat/${widget.roomId}');
    _normalModeDataRef = database.child('/normal_mode_data/${widget.roomId}');
    _roomRef = database.child('/rooms/${widget.roomId}');

    _roomRef.get().then((value) {
      final data = Map<String, dynamic>.from(
        value.value as Map<dynamic, dynamic>,
      );
      roomOwnerId = data['roomOwner'];
    });

    _normalModeDataRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      wordToGuess = data['wordToDraw'];
    });

    _chatRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );

      final newChat = data.entries.map((e) {
        return {
          "userName": e.value['userName'],
          "message": e.value['message'],
          "timestamp": e.value['timestamp'],
        };
      }).toList();

      ref.read(chatProvider.notifier).updateChat(newChat);

      // Cuộn xuống dòng cuối cùng
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      // Kiểm tra đoán đúng không
      final isRight = ref
          .read(chatProvider.notifier)
          .checkGuess(wordToGuess, widget.roomId);
      if (isRight) {
        // Người chơi thông báo người chơi đã đoán đúng
        if (true) {
          _normalModeDataRef.update({
            'userGuessed': ref.read(userProvider).id,
          });
          final userName = ref.read(userProvider).name;
          ref
              .read(chatProvider.notifier)
              .addMessage('$userName đã đoán đúng', 'Hệ thống', widget.roomId);
        }
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: width,
              child: SingleChildScrollView(
                controller: _scrollController,
                reverse: true, // Kéo ngược để hiển thị dòng cuối cùng trên cùng
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in ref.watch(chatProvider))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: item['userName'] != 'Hệ thống'
                            ? Text('${item['userName']}: ${item['message']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ))
                            : Center(
                                child: Text(
                                  '--${item['message']}--',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF00705A),
                                      ),
                                ),
                              ),
                      )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Nhập đáp án',
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
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      if (_controller.text.isEmpty) return;
                      ref.read(chatProvider.notifier).addMessage(
                            _controller.text,
                            ref.read(userProvider).name,
                            widget.roomId,
                          );
                      _controller.clear();
                    },
                    icon: Image.asset('assets/images/send.png'),
                    iconSize: 45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
