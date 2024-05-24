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
  late List<String> chat = ["ABCCC", "BBBBC"];
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    chat.add("ABC");
    chat.add("BCD");
  }

  void _addNewChat() {
    setState(() {
      final String message = _controller.text;
      print("New message: $message");
      _controller.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    return Container(
      width: width,
      color: Colors.blue,
      child: Column(
        children: [
          Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                width: width,
                color: Colors.amberAccent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Scroll horizontally
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var item in chat)
                        Text(item),
                    ],
                  ),
                ),
          )),
          Container(
            height: 80,
            color: Colors.amber,
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

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
