class Ohlc {
  final String time;
  final double open;
  final double high;
  final double low;
  final double close;

  Ohlc({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory Ohlc.fromJson(Map<String, dynamic> json) {
    return Ohlc(
      time: json['datetime'] ?? "",
      open: double.tryParse(json['open'].toString()) ?? 0.0,
      high: double.tryParse(json['high'].toString()) ?? 0.0,
      low: double.tryParse(json['low'].toString()) ?? 0.0,
      close: double.tryParse(json['close'].toString()) ?? 0.0,
    );
  }
}
