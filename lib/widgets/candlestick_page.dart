import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;

class CandlestickPage extends StatefulWidget {
  const CandlestickPage({super.key});

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<Candle> candles = [];
  bool isLoading = false;
  String interval = "1m"; // default interval
  String symbol = "BTCUSDT";
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchCandles();

    // auto-refresh tiap 1 detik
    refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchCandles();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchCandles() async {
    setState(() {
      isLoading = true;
    });

    final uri = Uri.parse(
      "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=100",
    );

    try {
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;

        final newCandles = data.map((e) {
          return Candle(
            date: DateTime.fromMillisecondsSinceEpoch(e[0], isUtc: true),
            open: double.parse(e[1]),
            high: double.parse(e[2]),
            low: double.parse(e[3]),
            close: double.parse(e[4]),
            volume: double.parse(e[5]),
          );
        }).toList().reversed.toList();

        setState(() {
          candles = newCandles;
          isLoading = false;
        });
      } else {
        throw Exception("Gagal ambil data Binance");
      }
    } catch (e) {
      debugPrint("Error fetchCandles: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candlestick $symbol"),
        actions: [
          DropdownButton<String>(
            value: interval,
            items: const [
              DropdownMenuItem(value: "1m", child: Text("1m")),
              DropdownMenuItem(value: "5m", child: Text("5m")),
              DropdownMenuItem(value: "15m", child: Text("15m")),
              DropdownMenuItem(value: "1h", child: Text("1h")),
              DropdownMenuItem(value: "4h", child: Text("4h")),
              DropdownMenuItem(value: "1d", child: Text("1d")),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  interval = val;
                });
                fetchCandles();
              }
            },
          ),
        ],
      ),
      body: isLoading && candles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : candles.isEmpty
              ? const Center(child: Text("Tidak ada data candlestick"))
              : Candlesticks(candles: candles),
    );
  }
}
