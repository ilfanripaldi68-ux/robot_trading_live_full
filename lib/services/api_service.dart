import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CandlestickPage extends StatefulWidget {
  const CandlestickPage({super.key});

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<Candle> candles = [];
  bool isLoading = true;

  // default symbol dan interval
  String symbol = "BTCUSDT";
  String interval = "1h";

  final List<String> intervals = ["1m", "5m", "15m", "1h", "1d"];

  @override
  void initState() {
    super.initState();
    fetchCandles();
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
            date: DateTime.fromMillisecondsSinceEpoch(e[0]),
            open: double.parse(e[1]),
            high: double.parse(e[2]),
            low: double.parse(e[3]),
            close: double.parse(e[4]),
            volume: double.parse(e[5]),
          );
        }).toList();

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
            items: intervals.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  interval = value;
                });
                fetchCandles();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : candles.isEmpty
              ? const Center(child: Text("Tidak ada data candlestick"))
              : Candlesticks(candles: candles),
    );
  }
}
