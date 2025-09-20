import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ohlc.dart';

class ApiService {
  static const String _baseUrl = "https://api.twelvedata.com";
  static const String _apiKey = "6ecef20290274c2aa0cce6a20f3690ee"; // ganti dengan API Key dari TwelveData

  Future<List<Ohlc>> fetchOhlc({
    required String symbol,
    String interval = "1min",
    int outputSize = 30,
  }) async {
    final url = Uri.parse(
      "$_baseUrl/time_series?symbol=$symbol&interval=$interval&outputsize=$outputSize&apikey=$_apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["values"] == null) {
        throw Exception("Data tidak ditemukan: ${data['message'] ?? 'Unknown error'}");
      }

      final values = data["values"] as List;
      return values.map((item) {
        return Ohlc(
          DateTime.parse(item["datetime"]),
          double.parse(item["open"]),
          double.parse(item["high"]),
          double.parse(item["low"]),
          double.parse(item["close"]),
        );
      }).toList().reversed.toList();
    } else {
      throw Exception("Failed to load OHLC data: ${response.statusCode}");
    }
  }
}
