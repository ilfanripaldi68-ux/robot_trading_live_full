import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import '../services/api_service.dart';

class CandlestickPage extends StatefulWidget {
  const CandlestickPage({super.key});

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<Candle> candles = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await ApiService.fetchCandles("BTCUSDT", "1m");
      setState(() {
        candles = data;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Binance Candlestick")),
      body: candles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Candlesticks(candles: candles),
    );
  }
}
