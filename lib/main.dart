import 'package:flutter/material.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const CritterWalkerApp());
}

class CritterWalkerApp extends StatelessWidget {
  const CritterWalkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainShell(),
    );
  }
}
