import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:candlesticks/candlesticks.dart';

class ApiService {
  static const String baseUrl = "https://api.binance.com/api/v3/klines";

  static Future<List<Candle>> fetchCandles(
    String symbol,
    String interval,
  ) async {
    final url = Uri.parse("$baseUrl?symbol=$symbol&interval=$interval&limit=100");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((e) {
        return Candle(
          date: DateTime.fromMillisecondsSinceEpoch(e[0]),
          open: double.parse(e[1]),
          high: double.parse(e[2]),
          low: double.parse(e[3]),
          close: double.parse(e[4]),
          volume: double.parse(e[5]),
        );
      }).toList();
    } else {
      throw Exception("Failed to fetch data from Binance");
    }
  }
}
