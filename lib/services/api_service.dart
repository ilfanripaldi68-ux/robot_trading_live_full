// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/ohlc.dart';

class ApiService {
  static const String _apiKey = "48863dadd04b4f2a9fc60ba5a69790c3"; // API key baru kamu
  static const String _baseUrl = "https://api.twelvedata.com";

  /// Ambil data candlestick
  static Future<List<Ohlc>> fetchCandles(
    String symbol,
    String interval, {
    int outputSize = 100,
  }) async {
    final s = symbol.replaceAll("/", "");
    final url = Uri.parse(
      "$_baseUrl/time_series?symbol=$s&interval=$interval&outputsize=$outputSize&format=JSON&apikey=$_apiKey",
    );

    final res = await http.get(url);
    if (res.statusCode == 200) {
      final j = jsonDecode(res.body);
      if (j['values'] == null) {
        throw Exception('No values in response: $j');
      }
      final List vals = j['values'];
      return vals
          .map((v) => Ohlc(
                DateTime.parse(v['datetime']),
                double.parse(v['open']),
                double.parse(v['high']),
                double.parse(v['low']),
                double.parse(v['close']),
              ))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
