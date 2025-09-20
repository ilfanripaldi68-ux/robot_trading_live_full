import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/api.dart';
import '../models/ohlc.dart';

class CandlestickPage extends StatefulWidget {
  final String symbol; // contoh: BTCUSDT, ETHUSDT
  final String interval; // contoh: 1m, 5m, 15m, 1h, 4h, 1d

  const CandlestickPage({
    Key? key,
    this.symbol = "BTCUSDT",
    this.interval = "1m",
  }) : super(key: key);

  @override
  _CandlestickPageState createState() => _CandlestickPageState();
}

class _CandlestickPageState extends State<CandlestickPage> {
  List<Ohlc> _candles = [];
  Timer? _timer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();

    // ⏳ Auto refresh tiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchCandles(
        widget.symbol,
        widget.interval,
      );
      setState(() {
        _candles = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error fetch candles: $e");
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
                  primaryYAxis: NumericAxis(
                    opposedPosition: true,
                    decimalPlaces: 2,
                  ),
                  series: <CandleSeries<Ohlc, DateTime>>[
                    CandleSeries<Ohlc, DateTime>(
                      dataSource: _candles,
                      xValueMapper: (Ohlc ohlc, _) => ohlc.date,
                      lowValueMapper: (Ohlc ohlc, _) => ohlc.low,
                      highValueMapper: (Ohlc ohlc, _) => ohlc.high,
                      openValueMapper: (Ohlc ohlc, _) => ohlc.open,
                      closeValueMapper: (Ohlc ohlc, _) => ohlc.close,
                    )
                  ],
                ),
    );
  }
}
