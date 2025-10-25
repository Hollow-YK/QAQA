import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'homepage.dart';

void main() {
  runApp(const QAQAApp());
  // 设置窗口标题
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = "QAQA 问答问答 V0.0.1 - Hollow";//Windows窗口标题
      appWindow.show();
    });
  }
}

class QAQAApp extends StatelessWidget {
  const QAQAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QAQA 问答问答',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(), // 首页
    );
  }
}