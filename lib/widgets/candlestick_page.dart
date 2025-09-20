import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'services/api_service.dart';

class CandlestickPage extends StatefulWidget {
  const CandlestickPage({super.key});

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<Candle> candles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCandles();
  }

  Future<void> loadCandles() async {
    try {
      final data = await ApiService.fetchCandlestickData(
        symbol: "BTCUSDT", // bisa diganti ETHUSDT, BNBUSDT, dll
        interval: "1m",    // bisa 1m, 5m, 1h, 1d
        limit: 100,
      );
      setState(() {
        candles = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Candlestick Binance")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text("Error: $errorMessage"))
              : Candlesticks(candles: candles),
    );
  }
}
