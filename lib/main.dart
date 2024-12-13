import 'package:flutter/material.dart';
import 'package:welcome_to_saudi_2034/firework.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: FireworksAnimation(),
        ),
      ),
    );
  }
}
