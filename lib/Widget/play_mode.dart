import 'package:flutter/material.dart';

class PlayMode extends StatefulWidget {
  const PlayMode({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.roomId,
    this.isLocked = false,
    required this.selecting,
  });

  final String imageAsset;
  final String title;
  final String roomId;
  final bool isLocked;
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
                    color: value == widget.title
                        ? const Color.fromARGB(255, 44, 104, 44)
                        : Colors.transparent,
                    width: value == widget.title ? 4.0 : 0.0,
                    strokeAlign: BorderSide.strokeAlignCenter)),
            child: Row(
              children: [
                SizedBox(
                  height: 110,
                  width: 110,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(widget.imageAsset),
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
                          widget.title,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Số người: ?/?',
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
                if (widget.isLocked)
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
