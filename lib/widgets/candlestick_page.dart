import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.time, this.open, this.high, this.low, this.close);
}

class CandlestickPage extends StatefulWidget {
  const CandlestickPage({super.key});

  @override
  State<CandlestickPage> createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<CandleData> _candles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCandles();
  }

  Future<void> fetchCandles() async {
    final url =
        "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=15m&limit=50";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      List<CandleData> candles = data.map((e) {
        return CandleData(
          DateTime.fromMillisecondsSinceEpoch(e[0]),
          double.parse(e[1]),
          double.parse(e[2]),
          double.parse(e[3]),
          double.parse(e[4]),
        );
      }).toList();

      setState(() {
        _candles = candles;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Candlestick BTCUSDT")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(),
              series: <CandleSeries>[
                CandleSeries<CandleData, DateTime>(
                  dataSource: _candles,
                  xValueMapper: (CandleData data, _) => data.time,
                  lowValueMapper: (CandleData data, _) => data.low,
                  highValueMapper: (CandleData data, _) => data.high,
                  openValueMapper: (CandleData data, _) => data.open,
                  closeValueMapper: (CandleData data, _) => data.close,
                )
              ],
            ),
    );
  }
}
