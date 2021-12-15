import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';

import '../models/product_model.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  AppStrings.addProduct,
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.2)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(4)))),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: PageData(),
    );
  }
}

class PageData extends HookWidget {
  List<ProductModel> products = [];

  PageData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 10; i++) {
      products.add(ProductModel("name", "launchedAt", "launchSite", 0.2));
    }
    return products.isEmpty
        ? const Center(child: Text(AppStrings.noDataFound))
        : ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final item = products[index];
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 20),),
                    Text(item.launchedAt, style: const TextStyle(fontSize: 20),),
                    Text(item.launchSite, style: const TextStyle(fontSize: 20),),
                    Row(
                      children: [
                        Expanded(child: Text(item.popularity.toString(), style: const TextStyle(fontSize: 20),), flex: 1,),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                          constraints: const BoxConstraints(maxHeight: 40),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                          constraints: const BoxConstraints(maxHeight: 40),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
