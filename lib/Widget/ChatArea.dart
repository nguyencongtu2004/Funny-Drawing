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
  late List<Map<String, dynamic>> chat = [];
  final TextEditingController _controller = TextEditingController();
  late DatabaseReference _chatRef;
  late DatabaseReference _normalModeDataRef;
  final ScrollController _scrollController = ScrollController();
  var wordToGuess = '';

  @override
  void initState() {
    super.initState();
    _chatRef = database.child('/chat/${widget.roomId}');
    _normalModeDataRef = database.child('/normal_mode_data/${widget.roomId}');

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
      setState(() {
        chat.clear();
        for (final message in data.entries) {
          chat.add({
            "userName": message.value['userName'],
            "message": message.value['message'],
            "timestamp": message.value['timestamp'],
          });
        }
        // Sắp xếp danh sách tin nhắn theo timestamp
        chat.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
        // Cuộn xuống dòng cuối cùng
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      // Kiểm tra đoán đúng không
      for (var item in chat) {
        if ((item['message'] as String).toLowerCase() ==
            wordToGuess.toLowerCase()) {
          _normalModeDataRef.update({
            'userGuessed': ref.watch(userProvider).id,
          });
        }
      }
    });
  }

  void _addNewChat() {
    final String message = _controller.text;
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    _chatRef.push().set({
      'userName': ref.read(userProvider).name,
      'message': message,
      'timestamp': timestamp,
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    return Container(
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
                    for (var item in chat)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "${item['userName']}: ${item['message']}",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
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
                    onPressed: _addNewChat,
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
