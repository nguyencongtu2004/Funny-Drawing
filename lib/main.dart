import 'package:draw_and_guess_promax/Screen/create_room.dart';
import 'package:draw_and_guess_promax/Screen/find_room.dart';
import 'package:draw_and_guess_promax/Screen/home_page.dart';
import 'package:flutter/material.dart';

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
          titleMedium: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
          bodyMedium: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            height: 0,
          ),
          bodySmall: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w200,
            height: 0,
          ),
        ),
      ),
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
