import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/screens/loan_calculator_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoanCalculatorScreen(),
    );
  }
}
