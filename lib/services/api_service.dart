// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/ohlc.dart';

class ApiService {
  static const String _apiKey = "3e94e14fdcf04d51864a4d505a071d4e"; // ganti kalau perlu
  static const String _baseUrl = "https://api.twelvedata.com";

  static Future<List<Ohlc>> fetchCandles(String symbol, String interval, {int outputSize = 100}) async {
    final s = symbol.replaceAll("/", "");
    final url = Uri.parse(
        "$_baseUrl/time_series?symbol=$s&interval=$interval&outputsize=$outputSize&format=JSON&apikey=$_apiKey");

    print("🔎 Request URL: $url");

    final res = await http.get(url);

    print("🔎 Status Code: ${res.statusCode}");
    print("🔎 Response Body: ${res.body}");

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body);

      if (j['values'] == null) {
        throw Exception('No values in response: $j');
      }

      final List vals = j['values'];

      final List<Ohlc> candles = vals.map((v) {
        // ambil key yang ada
        final dt = v['datetime'] ?? v['time'] ?? v['timestamp'];
        final o = v['open'] ?? v['o'];
        final h = v['high'] ?? v['h'];
        final l = v['low'] ?? v['l'];
        final c = v['close'] ?? v['c'];

        return Ohlc(
          DateTime.parse(dt.toString()),
          double.parse(o.toString()),
          double.parse(h.toString()),
          double.parse(l.toString()),
          double.parse(c.toString()),
        );
      }).toList().reversed.toList();

      return candles;
    } else {
      throw Exception('HTTP ${res.statusCode}: ' + res.body);
    }
  }
}
