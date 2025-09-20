import 'package:flutter/material.dart';
import '../models/ohlc.dart';

class CandlestickChart extends StatelessWidget {
  final List<Ohlc> candles;

  const CandlestickChart({Key? key, required this.candles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return const Center(child: Text("No data"));
    }

    return ListView.builder(
      itemCount: candles.length,
      itemBuilder: (context, i) {
        final c = candles[i];
        return ListTile(
          title: Text("${c.time}  O:${c.open}  H:${c.high}  L:${c.low}  C:${c.close}"),
        );
      },
    );
  }
}
