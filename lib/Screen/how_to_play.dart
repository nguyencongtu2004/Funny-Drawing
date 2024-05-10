import 'package:draw_and_guess_promax/Widget/play_mode_detail.dart';
import 'package:draw_and_guess_promax/data/play_mode_data.dart';
import 'package:flutter/material.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({Key? key});

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  void _onCloseClick(context) {
    Navigator.pop(context);
  }

  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF00C4A0), Color(0xFFD05700)])),
      child: Stack(
        children: [
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'CÁCH CHƠI',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 80,
            child: SingleChildScrollView(
              //padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Chế độ 1
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded1 = !_isExpanded1;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        height: _isExpanded1 ? 560.0 : 120.0,
                        //color: Colors.blue,
                        child: Center(
                          child: PlayModeDetail(
                            mode: availabePlayMode[0].mode,
                            description: availabePlayMode[0].description,
                            howToPlay: availabePlayMode[0].howToPlay,
                            isVisible: _isExpanded1,
                          ),
                        ),
                      ),
                    ),
                    // Chế độ 2
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded2 = !_isExpanded2;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        height: _isExpanded2 ? 490.0 : 120.0,
                        //color: Colors.blue,
                        child: Center(
                          child: PlayModeDetail(
                            mode: availabePlayMode[1].mode,
                            description: availabePlayMode[1].description,
                            howToPlay: availabePlayMode[1].howToPlay,
                            isVisible: _isExpanded2,
                          ),
                        ),
                      ),
                    ),
                    // Chế độ 3
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded3 = !_isExpanded3;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        height: _isExpanded3 ? 600.0 : 120.0,
                        //color: Colors.blue,
                        child: Center(
                          child: PlayModeDetail(
                            mode: availabePlayMode[2].mode,
                            description: availabePlayMode[2].description,
                            howToPlay: availabePlayMode[2].howToPlay,
                            isVisible: _isExpanded3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
          // Nút ok
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _onCloseClick(context);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 150),
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  shadowColor: const Color.fromARGB(0, 0, 0, 0),
                  surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
                ),
                child: Image.asset('assets/images/ok.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
