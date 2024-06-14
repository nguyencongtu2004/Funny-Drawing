import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF00C4A1),
            ),
            const SizedBox(height: 10),
            Text(
              'Đang tải...',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
