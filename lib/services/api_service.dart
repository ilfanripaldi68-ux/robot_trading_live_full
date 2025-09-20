import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ohlc.dart';

class ApiService {
  // 🔑 ganti dengan API key kamu
  static const String _apiKey = "6ecef20290274c2aa0cce6a20f3690ee";
  static const String _baseUrl = "https://api.twelvedata.com";

  static Future<List<Ohlc>> fetchCandles(
    String symbol,
    String interval, {
    int outputSize = 100,
  }) async {
    try {
      final s = symbol.replaceAll("/", ""); // contoh: "EUR/USD" -> "EURUSD"
      final url = Uri.parse(
        "$_baseUrl/time_series?symbol=$s"
        "&interval=$interval"
        "&outputsize=$outputSize"
        "&apikey=$_apiKey"
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);

        // kalau ada error dari API (contoh apikey salah)
        if (j is Map && j['status'] == 'error') {
          throw Exception(j['message'] ?? 'API error');
        }

        if (j['values'] == null) {
          throw Exception('No values in response');
        }

        final List vals = j['values'];

        // API return newest first, kita balik ke oldest first
        final List<Ohlc> candles = vals
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

        return candles;
      } else {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      throw Exception("fetchCandles error: $e");
    }
  }
}
