import 'package:flutter/material.dart';

class PickAvatarDialog extends StatelessWidget {
  const PickAvatarDialog({super.key, required this.onPick});

  final void Function(int) onPick;
  final int totalAvatar = 13;

  @override
  build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xFF00C4A0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        children: [
          Center(
              child: Text(
            'Chọn Avatar',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          )),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 470,
            width: double.infinity,
            child: SingleChildScrollView(
              child: SizedBox(
                height: (totalAvatar / 3).ceil() * 100.0,
                // Adjust this height as needed
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: totalAvatar,
                  itemBuilder: (BuildContext _, int index) {
                    return GestureDetector(
                      onTap: () {
                        onPick(index);
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/avatars/avatar$index.png'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
