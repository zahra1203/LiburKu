import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const NegaraKuApp());
}

class NegaraKuApp extends StatelessWidget {
  const NegaraKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NegaraKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}