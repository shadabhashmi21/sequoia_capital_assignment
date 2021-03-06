import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sequoia_capital_assignment/config/app_colors.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';
import 'package:sequoia_capital_assignment/screens/add_edit_product.dart';
import 'package:sequoia_capital_assignment/screens/dashboard.dart';

import 'config/routes.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// restrict direct routes access using routes
  if (kIsWeb) {
    final String? defaultRouteName =
        WidgetsBinding.instance?.window.defaultRouteName;
    if (!(defaultRouteName == AppRoutes.home)) {
      SystemNavigator.routeUpdated(
          routeName: AppRoutes.home, previousRouteName: null);
    }
  }
}

void main() {
  init().then((_) {
    runApp(Provider<List<ProductModel>>.value(value: [], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        theme:
            ThemeData(appBarTheme: AppBarTheme(color: AppColors.appbarColor)),
        routes: <String, WidgetBuilder>{
          AppRoutes.home: (context) => const DashboardPage(),
          AppRoutes.addProduct: (context) => const AddEditProduct(),
        });
  }
}
