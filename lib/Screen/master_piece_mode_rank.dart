import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MasterPieceModeRank extends ConsumerStatefulWidget {
  const MasterPieceModeRank({super.key});

  @override
  ConsumerState<MasterPieceModeRank> createState() =>
      _MasterPieceModeRankState();
}

class _MasterPieceModeRankState extends ConsumerState<MasterPieceModeRank> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // nền
        Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF00C4A0), Color(0xFFD05700)],
              ),
            )),
        // something...

        // App bar
        Container(
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(color: Color(0xFF00C4A1)),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Tuyệt tác',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
