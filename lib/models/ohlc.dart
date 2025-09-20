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
      time: json['datetime'],
      open: double.parse(json['open']),
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      close: double.parse(json['close']),
    );
  }
}
