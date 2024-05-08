import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.onClick,
      this.borderRadius = 10,
      this.imageAsset,
      this.title = 'Button'});

  final void Function(BuildContext context) onClick;
  final double borderRadius;
  final String? imageAsset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onClick(context);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(180, 50),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageAsset != null)
            Image.asset(
              imageAsset!,
              height: 22,
              width: 22,
            ),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
