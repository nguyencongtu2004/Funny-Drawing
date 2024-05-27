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
  ConsumerState<ChatArea> createState() => _ChatArea();
}

class _ChatArea extends ConsumerState<ChatArea> {
  late List<String> chat = [];
  final TextEditingController _controller = TextEditingController();
  late DatabaseReference _chatRef;

  @override
  void initState() {
    super.initState();

    _chatRef = database.child('/chat/${widget.roomId}');
    _chatRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );
      setState(() {
        chat.clear();
        for (final message in data.entries) {
          chat.add("${message.value['userName']}: ${message.value['message']}");
        }
      });
    });
  }

  void _addNewChat() {
    setState(() {
      final String message = _controller.text;

      _chatRef.push().set({
        'userName': ref.read(userProvider).name,
        'message': message,
      });
      _controller.clear();
    });
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
              scrollDirection: Axis.vertical, // Scroll horizontally
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in chat)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      // Add bottom padding
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          )),
          Container(
            height: 100,
            padding: const EdgeInsets.only(
                bottom: 15.0, top: 0.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập đáp án',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _addNewChat();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
