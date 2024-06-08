import 'package:flutter/material.dart';

class NormalModeStatus extends StatelessWidget {
  const NormalModeStatus({
    super.key,
    required this.status,
    required this.timeLeft,
  });

  final String status;
  final int timeLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            status,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: timeLeft < 10 ? Colors.red : Colors.transparent,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            timeLeft < 10 ? "0$timeLeft" : timeLeft.toString(),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
