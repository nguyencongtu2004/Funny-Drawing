import 'package:flutter/material.dart';

class ChatArea extends StatefulWidget {
  ChatArea({
    super.key,
    required this.roomId,
    required this.width,
  });

  final String roomId;
  final double width;
  @override
  State<ChatArea> createState() => _ChatArea();
}

class _ChatArea extends State<ChatArea> {
  late List<String> chat = ["Player1: Con cho", "Player2: Con ga"];
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void _addNewChat() {
    setState(() {
      final String message = _controller.text;
      chat.add("Player 7: $message");
      print("New message: $message");
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
                padding: EdgeInsets.all(15),
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Scroll horizontally
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in chat)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0), // Add bottom padding
                          child: Text(item,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        ),
                    ],
                  ),
                ),
          )),
          Container(
            height: 100,
             padding: const EdgeInsets.only(bottom: 15.0, top: 0.0, left: 15.0, right: 15.0),
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
