class Ohlc {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  Ohlc({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory Ohlc.fromJson(List<dynamic> json) {
    return Ohlc(
      time: DateTime.fromMillisecondsSinceEpoch(json[0]),
      open: double.parse(json[1]),
      high: double.parse(json[2]),
      low: double.parse(json[3]),
      close: double.parse(json[4]),
      volume: double.parse(json[5]),
    );
  }
}
