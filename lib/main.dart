import 'package:flutter/material.dart';
import 'package:webspark_test/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Webspark Test Ihnatiev'),
          backgroundColor: Colors.blue.shade300,
        ),
        body: const HomeScreen(),
      ),
    );
  }
}
