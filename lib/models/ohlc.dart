class Ohlc {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  Ohlc({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  // Convert Binance response ke model
  factory Ohlc.fromBinance(List<dynamic> json) {
    return Ohlc(
      date: DateTime.fromMillisecondsSinceEpoch(json[0]),
      open: double.parse(json[1]),
      high: double.parse(json[2]),
      low: double.parse(json[3]),
      close: double.parse(json[4]),
    );
  }
}
