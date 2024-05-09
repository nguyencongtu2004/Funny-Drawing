import 'package:flutter/material.dart';

class PlayMode extends StatefulWidget {
  const PlayMode({
    super.key,
    required this.mode,
    required this.roomId,
    this.isPrivate = false,
    required this.selecting,
    required this.curPlayer,
    required this.maxPlayer,
  });

  final String mode;
  final String roomId;
  final bool isPrivate;
  final int curPlayer;
  final int maxPlayer;
  final ValueNotifier<String> selecting;

  @override
  State<PlayMode> createState() => _PlayModeState();
}

class _PlayModeState extends State<PlayMode> {
  late final ValueListenableBuilder<String> _valueListenableBuilder;

  @override
  void initState() {
    super.initState();
    _valueListenableBuilder = ValueListenableBuilder<String>(
        valueListenable: widget.selecting,
        builder: (context, value, child) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: BorderSide(
                    color: value == widget.roomId
                        ? const Color.fromARGB(255, 44, 104, 44)
                        : Colors.transparent,
                    width: value == widget.roomId ? 4.0 : 0.0,
                    strokeAlign: BorderSide.strokeAlignCenter)),
            child: Row(
              children: [
                SizedBox(
                  height: 110,
                  width: 110,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(widget.mode == 'Thường'
                        ? 'assets/images/thuong_mode.png'
                        : widget.mode == 'Tam sao thất bản'
                            ? 'assets/images/tam_sao_that_ban_mode.png'
                            : 'assets/images/tuyet_tac_mode.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mode,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Số người: ${widget.curPlayer}/${widget.maxPlayer}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'ID phòng: ${widget.roomId}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.isPrivate)
                  SizedBox(
                    height: 40,
                    child: Image.asset('assets/images/lock.png'),
                  ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _valueListenableBuilder;
  }
}
