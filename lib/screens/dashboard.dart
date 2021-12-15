import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
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
                        const EdgeInsets.symmetric(horizontal: 10)))),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: const _PageData(),
    );
  }
}

class _PageData extends HookWidget {

  const _PageData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productList = useState(Provider.of<List<ProductModel>>(context));

    return productList.value.isEmpty
        ? const Center(child: Text(AppStrings.noDataFound))
        : ListView.builder(
            itemCount: productList.value.length,
            itemBuilder: (BuildContext context, int index) {
              final item = productList.value[index];
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      item.launchedAt,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      item.launchSite,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RatingBar.builder(
                            initialRating: item.popularity,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 15,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (rating) {},
                          ),
                          flex: 1,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                          constraints: const BoxConstraints(maxHeight: 40),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(AppStrings.deleteItem),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            productList.value.removeAt(index);
                                            productList.value = List.from(productList.value);
                                          },
                                          child: const Text(AppStrings.yes)),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(AppStrings.no))
                                    ],
                                  );
                                });
                          },
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
