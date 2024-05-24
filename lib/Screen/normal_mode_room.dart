import 'package:flutter/material.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';
import 'package:draw_and_guess_promax/Widget/ChatWidget.dart';

class NormalModeRoom extends StatefulWidget {
  NormalModeRoom({
    super.key,
    required this.roomId
  });

  final String roomId;
  @override
  State<NormalModeRoom> createState() => _NormalModeRoomState();
}
class _NormalModeRoomState extends State<NormalModeRoom> {
  // MediaQuery.of(context).size.height
  late String _wordToDraw;
  late bool _isOpenChat = false;
  @override
  void initState() {
    super.initState();
    _wordToDraw = "Con ga";
    _isOpenChat = false;
  }
  void _openChat() {
    setState(() {
      _isOpenChat = !_isOpenChat;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_wordToDraw),
        backgroundColor: Color(0xFF00C4A1),
        actions: [
          // Add your desired icon button here
          IconButton(
            icon: Icon(Icons.chat, color: Colors.black,), // Replace with your icon
            onPressed: () {
              _openChat();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Drawing(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                  )
              ),
              AnimatedPositioned(
                bottom: _isOpenChat ? 0 : -constraints.maxHeight*2/3,
                left: 0.0,
                duration: const Duration(milliseconds: 300), // Adjust animation duration
                curve: Curves.easeInCubic, // Customize animation curve
                child: Container(
                  height: constraints.maxHeight*2/3,
                  width: constraints.maxWidth,
                  color: Colors.white, // Or your preferred chat background color
                  child: Chat(roomId: widget.roomId, height: constraints.maxHeight*2/3, width: constraints.maxWidth),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}