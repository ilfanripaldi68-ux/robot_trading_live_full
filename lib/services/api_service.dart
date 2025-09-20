import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ohlc.dart';

class ApiService {
  static const String _baseUrl = "https://api.twelvedata.com";
  static const String _apiKey = "6ecef20290274c2aa0cce6a20f3690ee"; // ganti pakai key kamu

  static Future<List<Ohlc>> fetchCandles(
      String symbol, String interval,
      {int outputSize = 50}) async {
    final url =
        Uri.parse("$_baseUrl/time_series?symbol=$symbol&interval=$interval&outputsize=$outputSize&apikey=$_apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "error") {
        throw Exception(data["message"]);
      }

      final values = data["values"] as List<dynamic>;
      return values.map((v) {
        return Ohlc(
          DateTime.parse(v["datetime"]),
          double.parse(v["open"]),
          double.parse(v["high"]),
          double.parse(v["low"]),
          double.parse(v["close"]),
        );
      }).toList();
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
}
