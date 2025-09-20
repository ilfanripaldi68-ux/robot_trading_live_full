import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://api.twelvedata.com";
  static const String _apiKey = "48863dadd04b4f2a9fc60ba5a69790c3"; // <- cek lagi bener

  static Future<Map<String, dynamic>?> getTimeSeries(String symbol) async {
    try {
      final s = symbol.replaceAll("/", ""); // EUR/USD -> EURUSD
      final url = Uri.parse("$_baseUrl/time_series?symbol=$s&interval=1min&apikey=$_apiKey");

      print("🔗 Request URL: $url"); // log url
      final response = await http.get(url);

      print("📩 Response status: ${response.statusCode}");
      print("📩 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "error") {
          print("❌ API Error: ${data["message"]}");
          return null;
        }
        return data;
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return null;
    }
  }
}
