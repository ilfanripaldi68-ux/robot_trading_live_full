// lib/models/ohlc.dart
class Ohlc {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double? volume; // optional

  Ohlc({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });
}
