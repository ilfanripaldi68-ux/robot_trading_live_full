import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Candle {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class CandlestickPage extends StatefulWidget {
  final String symbol;
  final String interval;

  const CandlestickPage({
    super.key,
    required this.symbol,
    required this.interval,
  });

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<Candle> _candles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCandles();
  }

  Future<void> fetchCandles() async {
    final uri = Uri.parse(
        'https://api.binance.com/api/v3/klines?symbol=${widget.symbol}&interval=${widget.interval}&limit=100');
    try {
      final res = await http.get(uri);

      debugPrint("Status: ${res.statusCode}");
      debugPrint("Body: ${res.body.substring(0, 200)}...");

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        final candles = data.map((e) {
          return Candle(
            time: DateTime.fromMillisecondsSinceEpoch(e[0]),
            open: (e[1] as String).isNotEmpty ? double.parse(e[1]) : 0,
            high: (e[2] as String).isNotEmpty ? double.parse(e[2]) : 0,
            low: (e[3] as String).isNotEmpty ? double.parse(e[3]) : 0,
            close: (e[4] as String).isNotEmpty ? double.parse(e[4]) : 0,
            volume: (e[5] as String).isNotEmpty ? double.parse(e[5]) : 0,
          );
        }).toList();

        setState(() {
          _candles = candles;
          _loading = false;
        });
      } else {
        debugPrint("Error response: ${res.body}");
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint("Exception: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candlestick ${widget.symbol}"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _candles.isEmpty
              ? const Center(child: Text("Tidak ada data candlestick"))
              : SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  series: <CandleSeries>
