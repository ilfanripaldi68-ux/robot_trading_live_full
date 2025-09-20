// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/ohlc.dart';

class ApiService {
  static const String _apiKey = "2444d7e7875a4365a357f4d6149ae63c"; 
  static const String _baseUrl = "https://api.twelvedata.com";

  static Future<List<Ohlc>> fetchCandles(String symbol, String interval, {int outputSize = 100}) async {
    final url = Uri.parse("$_baseUrl/time_series?symbol=$symbol&interval=$interval&outputsize=$outputSize&format=JSON&apikey=$_apiKey");
    final res = await http.get(url);

    print("API URL: $url");
    print("Response: ${res.body}");

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body);

      if (j['status'] == 'error') {
        throw Exception('API error: ${j['message']}');
      }

      if (j['values'] == null) {
        throw Exception('No values in response: $j');
      }

      final List vals = j['values'];
      final List<Ohlc> candles = vals.map((v) => Ohlc(
        DateTime.parse(v['datetime']),
        double.parse(v['open']),
        double.parse(v['high']),
        double.parse(v['low']),
        double.parse(v['close']),
      )).toList().reversed.toList();

      return candles;
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}
