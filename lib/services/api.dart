import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ohlc.dart';

class ApiService {
  static const String baseUrl = "https://api.binance.com";

  static Future<List<Ohlc>> fetchCandles(String symbol, String interval,
      {int limit = 50}) async {
    final url = Uri.parse(
        "$baseUrl/api/v3/klines?symbol=$symbol&interval=$interval&limit=$limit");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Ohlc.fromBinance(item)).toList();
    } else {
      throw Exception("Gagal fetch data dari Binance");
    }
  }
}
