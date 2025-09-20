import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.binance.com";

  /// Ambil data candlestick
  Future<List<Map<String, dynamic>>> fetchCandlestickData({
    String symbol = "BTCUSDT",
    String interval = "1m",
    int limit = 50,
  }) async {
    final url = Uri.parse(
        "$baseUrl/api/v3/klines?symbol=$symbol&interval=$interval&limit=$limit");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // Convert array Binance ke format map
      return data.map((e) {
        return {
          "openTime": e[0],
          "open": double.parse(e[1]),
          "high": double.parse(e[2]),
          "low": double.parse(e[3]),
          "close": double.parse(e[4]),
          "volume": double.parse(e[5]),
          "closeTime": e[6],
        };
      }).toList();
    } else {
      throw Exception(
          "Gagal load data candlestick: ${response.statusCode} - ${response.body}");
    }
  }
}
