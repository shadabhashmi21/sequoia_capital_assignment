import 'package:flutter/material.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      home: DashboardPage(),
    );
  }
}
