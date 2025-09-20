import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/ohlc.dart';
import 'widgets/candlestick_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robot Trading Live',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Ohlc>> candlesFuture;

  @override
  void initState() {
    super.initState();
    candlesFuture = ApiService.fetchCandles("BTC/USD", "1min", outputSize: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Robot Trading Live"),
      ),
      body: FutureBuilder<List<Ohlc>>(
        future: candlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final candles = snapshot.data!;
          return CandlestickChart(candles: candles);
        },
      ),
    );
  }
}
