// lib/utils/ohlc.dart
class Candle {
  final DateTime time;
  final double open, high, low, close;
  Candle(this.time, this.open, this.high, this.low, this.close);
}
