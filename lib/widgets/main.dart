import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart'; // pastikan ini ada

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // contoh data candlestick (ganti dengan data asli kamu)
  List<Candle> candles = [
    Candle(
      date: DateTime.now(),
      high: 100,
      low: 90,
      open: 95,
      close: 98,
      volume: 1000,
    ),
    Candle(
      date: DateTime.now().subtract(const Duration(days: 1)),
      high: 105,
      low: 85,
      open: 90,
      close: 92,
      volume: 1200,
    ),
  ];

  // contoh hasil analisis indikator
  Map<String, double> analysis = {
    'rsi': 56.23,
    'atr': 0.004562,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Robot Trading Live")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // ✅ Perbaikan di sini → tidak ada lagi error koma
            Text(
              'RSI: ${(analysis['rsi'] ?? 0).toStringAsFixed(2)} '
              'ATR: ${(analysis['atr'] ?? 0).toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // ✅ CandlestickChart sekarang pakai widget Candlesticks dari package
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Candlesticks(candles: candles),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
