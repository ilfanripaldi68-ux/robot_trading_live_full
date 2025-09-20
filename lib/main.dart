import 'package:flutter/material.dart';
import 'models/ohlc.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Candlestick Data")),
        body: const CandleList(),
      ),
    );
  }
}

class CandleList extends StatefulWidget {
  const CandleList({super.key});

  @override
  State<CandleList> createState() => _CandleListState();
}

class _CandleListState extends State<CandleList> {
  late Future<List<Ohlc>> candles;

  @override
  void initState() {
    super.initState();
    candles = ApiService.fetchCandles("AAPL", "1h"); // contoh: saham Apple
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ohlc>>(
      future: candles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        } else {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final c = data[index];
              return ListTile(
                title: Text(
                    "${c.datetime}  O:${c.open}  H:${c.high}  L:${c.low}  C:${c.close}"),
              );
            },
          );
        }
      },
    );
  }
}
