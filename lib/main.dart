import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';
import 'package:sequoia_capital_assignment/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// todo - remove hardcoded products
    List<ProductModel> products = [];
    for (int i = 0; i < 10; i++) {
      products.add(ProductModel("name - "+i.toString(), "launchedAt", "launchSite", 3));
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      home: Provider<List<ProductModel>>.value(
          value: products, child: const DashboardPage()),
    );
  }
}
