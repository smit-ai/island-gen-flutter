import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/counter_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: IslandGeneratorApp(),
    ),
  );
}

class IslandGeneratorApp extends StatelessWidget {
  const IslandGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Island Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}
