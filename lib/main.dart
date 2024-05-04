import 'package:draw_and_guess_promax/Screen/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:draw_and_guess_promax/Screen/Drawing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
          textTheme: const TextTheme().copyWith(
        titleLarge: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      )),
      home: HomePage(),
    );
  }
}
