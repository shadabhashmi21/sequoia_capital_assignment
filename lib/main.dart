import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequoia_capital_assignment/config/app_colors.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';
import 'package:sequoia_capital_assignment/screens/dashboard.dart';

void main() {
  /// todo - remove hardcoded products
  List<ProductModel> products = [];
  for (int i = 1; i <= 5; i++) {
    products.add(
        ProductModel(i.toString(), (10-i).toString(), "launchSite"+i.toString(), i.toDouble()));
  }

  runApp(Provider<List<ProductModel>>.value(
      value: products, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: AppColors.appbarColor
        )
      ),
      home: const DashboardPage(),
    );
  }
}
