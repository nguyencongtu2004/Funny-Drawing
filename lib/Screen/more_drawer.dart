import 'package:draw_and_guess_promax/Screen/how_to_play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreDrawer extends StatelessWidget {
  const MoreDrawer({super.key});

  final buttonSize = const Size(100, 100);

  void _onCloseClick(context) {
    // Xử lý khi nút Close được nhấn
    Navigator.pop(context);
  }

  _launchURL(String link) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // can't launch url
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF00C4A0), Color(0xFFD05700)])),
      child: Stack(
        children: [
          // App bar
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _onCloseClick(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 90),
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    shadowColor: const Color.fromARGB(0, 0, 0, 0),
                    surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Image.asset('assets/images/close.png'),
                ),
              ],
            ),
          ),
          // Logo + nút
          Positioned(
            top: 135,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: 160,
                  height: 150,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'TRANG CHỦ',
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                const SizedBox(height: 5),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HowToPlay()));
                    },
                    child: Text(
                      'CÁCH CHƠI',
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                const SizedBox(height: 5),
                TextButton(
                    onPressed: () {
                      _launchURL("https://www.youtube.com/watch?v=tiM2ZWLXKT4");
                    },
                    child: Text(
                      'GÓP Ý',
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
              ],
            ),
          ),

          // Nút liên hệ
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _launchURL("https://www.youtube.com/watch?v=tiM2ZWLXKT4");
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    shadowColor: const Color.fromARGB(0, 0, 0, 0),
                    surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Image.asset('assets/images/facebook.png'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _launchURL("https://www.youtube.com/watch?v=tiM2ZWLXKT4");
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    shadowColor: const Color.fromARGB(0, 0, 0, 0),
                    surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Image.asset('assets/images/youtube.png'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _launchURL("https://www.youtube.com/watch?v=tiM2ZWLXKT4");
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    shadowColor: const Color.fromARGB(0, 0, 0, 0),
                    surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  child: Image.asset('assets/images/instagram.png'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
