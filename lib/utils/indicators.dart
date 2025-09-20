// lib/utils/indicators.dart
import 'ohlc.dart';
import 'dart:math';

double sma(List<double> data, int period) {
  if (data.length < period) return 0;
  final sub = data.sublist(data.length - period);
  return sub.reduce((a, b) => a + b) / period;
}

double ema(List<double> data, int period) {
  if (data.length < period) return 0;
  double k = 2 / (period + 1);
  double emaPrev = data[data.length - period];
  for (int i = data.length - period + 1; i < data.length; i++) {
    emaPrev = data[i] * k + emaPrev * (1 - k);
  }
  return emaPrev;
}

double rsi(List<double> closes, {int period = 14}) {
  if (closes.length < period + 1) return 50;
  double gain = 0, loss = 0;
  for (int i = closes.length - period; i < closes.length; i++) {
    final diff = closes[i] - closes[i - 1];
    if (diff >= 0) gain += diff; else loss -= diff;
  }
  if (loss == 0) return 100;
  final rs = gain / loss;
  return 100 - (100 / (1 + rs));
}

double atr(List<Ohlc> candles, {int period = 14}) {
  if (candles.length < period + 1) return 0;
  List<double> trs = [];
  for (int i = candles.length - period; i < candles.length; i++) {
    final high = candles[i].high;
    final low = candles[i].low;
    final prevClose = candles[i - 1].close;
    final tr = [high - low, (high - prevClose).abs(), (low - prevClose).abs()].reduce(max);
    trs.add(tr);
  }
  return trs.reduce((a, b) => a + b) / trs.length;
}

// combined signal & TP/SL calculation
Map<String, dynamic> analyze(List<Ohlc> candles) {
  if (candles.length < 20) return {'signal': 'WAIT'};
  final closes = candles.map((c) => c.close).toList();
  final double sma5 = sma(closes, 5);
  final double sma20 = sma(closes, 20);
  final double r = rsi(closes);
  String signal = 'HOLD';
  if (sma5 > sma20 && r < 70) signal = 'BUY';
  if (sma5 < sma20 && r > 30) signal = 'SELL';
  final double atrv = atr(candles);
  final double entry = candles.last.close;
  double tp = entry, sl = entry;
  if (signal == 'BUY') { tp = entry + atrv * 2; sl = entry - atrv; }
  if (signal == 'SELL') { tp = entry - atrv * 2; sl = entry + atrv; }
  return {'signal': signal, 'entry': entry, 'tp': tp, 'sl': sl, 'sma5': sma5, 'sma20': sma20, 'rsi': r, 'atr': atrv};
}
