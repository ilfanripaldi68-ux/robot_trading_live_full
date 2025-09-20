import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ohlc.dart';

class ApiService {
  static const String baseUrl = "https://api.twelvedata.com";
  static const String apiKey = "6ecef20290274c2aa0cce6a20f3690ee";

  static Future<List<Ohlc>> fetchCandles(
    String symbol,
    String interval, {
    int outputSize = 30,
  }) async {
    final url = Uri.parse(
      "$baseUrl/time_series?symbol=$symbol&interval=$interval&outputsize=$outputSize&apikey=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["values"] != null) {
        return (data["values"] as List)
            .map((item) => Ohlc.fromJson(item))
            .toList()
            .reversed
            .toList();
      } else {
        throw Exception("No data found");
      }
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }
}
