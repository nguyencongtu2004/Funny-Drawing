import 'package:flutter/material.dart';
import 'package:draw_and_guess_promax/Widget/Drawing.dart';

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
  @override
  void initState() {
    super.initState();
    _wordToDraw = "Con ga";
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
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Drawing(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
          );
        },
      ),
    );
  }
}