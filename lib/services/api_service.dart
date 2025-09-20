import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ohlc.dart';

class ApiService {
  static const String _apiKey = "6ecef20290274c2aa0cce6a20f3690ee"; // ganti dengan API key TwelveData kamu
  static const String _baseUrl = "https://api.twelvedata.com";

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

      if (j['status'] == "error") {
        throw Exception("API error: ${j['message']}");
      }

      if (j['values'] == null) {
        throw Exception("No values in response: $j");
      }

      final List vals = j['values'];

      // TwelveData kasih data newest → oldest, jadi kita balik
      final List<Ohlc> candles =
          vals.map((v) => Ohlc.fromJson(v)).toList().reversed.toList();

      return candles;
    } else {
      throw Exception("HTTP ${res.statusCode}: ${res.body}");
    }
  }
}
