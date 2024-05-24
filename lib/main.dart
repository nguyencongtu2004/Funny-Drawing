import 'dart:io';

import 'package:draw_and_guess_promax/Screen/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Extension để encode và decode Offset
extension OffsetExtension on Offset {
  Map<String, double> toJson() {
    return {
      'dx': dx,
      'dy': dy,
    };
  }

  static Offset fromJson(Map<String, dynamic> json) {
    return Offset(
      json['dx'],
      json['dy'],
    );
  }
}

// Hàm encode danh sách Offset
List<Map<String, double>> encodeOffsetList(List<Offset> offsets) {
  return offsets.map((offset) => offset.toJson()).toList();
}

// Hàm decode danh sách Offset
List<Offset> decodeOffsetList(List<dynamic> jsonList) {
  return jsonList.map((json) => OffsetExtension.fromJson(json)).toList();
}

void main() async {
  // Kết nối Firebase
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAN5w4LhO_J86gaM530epJOtprZ0QAOjdc',
        appId: '1:289465409378:android:348e2044d1f7d800de163b',
        messagingSenderId: '289465409378',
        projectId: 'draw-and-guest',
        storageBucket: 'draw-and-guest.appspot.com',
        databaseURL: 'https://draw-and-guest-default-rtdb.asia-southeast1.firebasedatabase.app',
      ),
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAN5w4LhO_J86gaM530epJOtprZ0QAOjdc',
        appId: '1:289465409378:ios:e201c7f592add358de163b',
        messagingSenderId: '289465409378',
        projectId: 'draw-and-guest',
        storageBucket: 'draw-and-guest.appspot.com',
        databaseURL: 'https://draw-and-guest-default-rtdb.asia-southeast1.firebasedatabase.app',
        iosBundleId: 'com.your.bundle.id',  // Thêm iosBundleId nếu cần
      ),
    );
  }
  List<Offset> points = [
    Offset(1.0, 2.0),
    Offset(3.0, 4.0),
    Offset(5.0, 6.0),
  ];
  print("Encode: ");
  print(encodeOffsetList(points).runtimeType);
  print("Decode: ");
  print(encodeOffsetList(points));

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
