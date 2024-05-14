import 'dart:io';

import 'package:draw_and_guess_promax/Screen/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // Kết nối Firebase
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyAN5w4LhO_J86gaM530epJOtprZ0QAOjdc',
          appId: '1:289465409378:android:348e2044d1f7d800de163b',
          messagingSenderId: '289465409378',
          projectId: 'draw-and-guest',
          storageBucket: 'draw-and-guest.appspot.com',
          databaseURL:
              'https://draw-and-guest-default-rtdb.asia-southeast1.firebasedatabase.app',
        ))
      : await Firebase.initializeApp();

  runApp(const DrawAndGuestApp());
}

class DrawAndGuestApp extends StatelessWidget {
  const DrawAndGuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = HomePage();

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
      home: Scaffold(body: content),
    );
  }
}
