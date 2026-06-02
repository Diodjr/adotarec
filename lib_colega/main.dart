import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adota Rec',
      home: const HomePage(),
    );
  }
}
