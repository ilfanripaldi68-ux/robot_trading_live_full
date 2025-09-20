import 'package:flutter/material.dart';
import 'candlestick_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robot Trading Live',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CandlestickPage(),
    );
  }
}
