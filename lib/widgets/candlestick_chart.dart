import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CandlestickPage extends StatefulWidget {
  const CandlestickPage({super.key});

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> candles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCandles();
  }

  Future<void> loadCandles() async {
    try {
      final data = await api.fetchCandlestickData(
        symbol: "BTCUSDT", // bisa diganti ETHUSDT, BNBUSDT, dll
        interval: "1m",
        limit: 30,
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
      appBar: AppBar(title: const Text("Candlestick Data")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text("Error: $errorMessage"))
              : ListView.builder(
                  itemCount: candles.length,
                  itemBuilder: (context, index) {
                    final c = candles[index];
                    return ListTile(
                      title: Text(
                          "O: ${c['open']} | H: ${c['high']} | L: ${c['low']} | C: ${c['close']}"),
                      subtitle: Text("Volume: ${c['volume']}"),
                    );
                  },
                ),
    );
  }
}
