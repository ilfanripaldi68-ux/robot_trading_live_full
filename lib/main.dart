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
      title: 'Robot Trading Live',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
  String symbol = "EUR/USD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Robot Trading Live"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // refresh data
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown pair
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: symbol,
              items: const [
                DropdownMenuItem(
                    value: "EUR/USD", child: Text("EUR/USD")),
                DropdownMenuItem(
                    value: "GBP/USD", child: Text("GBP/USD")),
                DropdownMenuItem(
                    value: "USD/JPY", child: Text("USD/JPY")),
              ],
              onChanged: (value) {
                setState(() {
                  symbol = value!;
                });
              },
            ),
          ),

          // Chart / Error / Loading
          Expanded(
            child: FutureBuilder<List<Ohlc>>(
              future:
                  ApiService.fetchCandles(symbol, "1min", outputSize: 100),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  re
