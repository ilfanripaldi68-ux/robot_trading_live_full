// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:candlesticks/candlesticks.dart' as cs;
import 'services/api_service.dart';
import 'utils/indicators.dart';
import 'utils/ohlc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notifications = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await notifications.initialize(initSettings);
  runApp(MyApp(notifications: notifications));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notifications;
  const MyApp({super.key, required this.notifications});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Robot Trading Live', debugShowCheckedModeBanner: false, home: HomeScreen(notifications: notifications));
  }
}

class HomeScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notifications;
  const HomeScreen({super.key, required this.notifications});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Ohlc> candles = [];
  Timer? timer;
  String currentPair = 'EUR/USD';
  String signal = 'WAIT';
  Map<String, dynamic> analysis = {};

  final pairs = ['EUR/USD', 'BTC/USDT', 'XAU/USD'];

  @override
  void initState() {
    super.initState();
    _fetch();
    timer = Timer.periodic(const Duration(seconds: 60), (_) => _fetch());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    try {
      final symbol = currentPair.replaceAll('/', '');
      final c = await ApiService.fetchCandles(symbol, '1min', outputSize: 100);
      setState(() { candles = c; });
      final res = analyze(candles);
      if (res['signal'] != signal) {
        signal = res['signal'];
        analysis = res;
        _notifySignal(res);
      } else {
        analysis = res;
      }
    } catch (e) {
      print('fetch error: $e');
    }
  }

  Future<void> _notifySignal(Map<String, dynamic> res) async {
    final androidDetails = AndroidNotificationDetails('trading_channel','Trading Signals',importance: Importance.high,priority: Priority.high);
    final details = NotificationDetails(android: androidDetails);
    final entry = res['entry'] ?? 0;
    final tp = res['tp'] ?? 0;
    final sl = res['sl'] ?? 0;
    await widget.notifications.show(0, 'Signal: ${res['signal']}', 'Entry: ${entry.toStringAsFixed(5)} TP: ${tp.toStringAsFixed(5)} SL: ${sl.toStringAsFixed(5)}', details);
  }

  @override
  Widget build(BuildContext context) {
    final entry = analysis['entry'] ?? 0.0;
    final tp = analysis['tp'] ?? 0.0;
    final sl = analysis['sl'] ?? 0.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Robot Trading Live')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Row(children: [
            Expanded(child: DropdownButton<String>(value: currentPair, items: pairs.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v){ if(v!=null){ setState(()=>currentPair=v); _fetch(); }})),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _fetch, child: const Text('Refresh')),
          ]),
          const SizedBox(height: 12),
          // gunakan widget Candlesticks dari package; konversi Ohlc -> cs.Candle
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: candles.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : cs.Candlesticks(
                      candles: candles.map((o) => cs.Candle(
                        date: o.time,
                        open: o.open,
                        high: o.high,
                        low: o.low,
                        close: o.close,
                        volume: 0, // kalau ada volume di API, set di sini
                      )).toList(),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Signal: $signal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: signal=='BUY'?Colors.green:signal=='SELL'?Colors.red:Colors.black)),
            const SizedBox(height: 6),
            Text('Entry: ${entry.toStringAsFixed(5)}'),
            Text('TP: ${tp.toStringAsFixed(5)}'),
            Text('SL: ${sl.toStringAsFixed(5)}'),
            const SizedBox(height: 8),
            Text('SMA5: ${(analysis['sma5'] ?? 0).toStringAsFixed(5)}   SMA20: ${(analysis['sma20'] ?? 0).toStringAsFixed(5)}'),
            Text('RSI: ${(analysis['rsi'] ?? 0).toStringAsFixed(2)}   ATR: ${(analysis['atr'] ?? 0).toStringAsFixed(6)}'),
          ]))),
        ]),
      ),
    );
  }
}
