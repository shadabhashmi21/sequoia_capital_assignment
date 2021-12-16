import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/extensions.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';
import 'package:sequoia_capital_assignment/screens/AddEditProduct.dart';

import '../models/product_model.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productList = useState(Provider.of<List<ProductModel>>(context));

    Future<void> gotoAddProduct() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddEditProduct()),
      );
      productList.value.add(result['productModel']);
      productList.value = List.from(productList.value);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextButton(
                onPressed: () {
                  gotoAddProduct();
                },
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
      body: _PageData(productList),
    );
  }
}

class _PageData extends HookWidget {
  final ValueNotifier<List<ProductModel>> productList;

  const _PageData(this.productList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void updateList() {
      productList.value = List.from(productList.value);
    }

    Future<void> gotoEditProduct(int index, ProductModel productModel) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditProduct(updateIndex: index, productModel: productModel)),
      );
      productList.value.update(result['updatingIndex'], result['productModel']);
      updateList();
    }

    return productList.value.isEmpty
        ? const Center(child: Text(AppStrings.noDataFound))
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: productList.value.length,
            itemBuilder: (BuildContext context, int index) {
              final item = productList.value[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: Text(
                        item.launchedAt,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: Text(
                        item.launchSite,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RatingBar.builder(
                            initialRating: item.popularity,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 15,
                            allowHalfRating: true,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (rating) {},
                          ),
                          flex: 1,
                        ),
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          ),
                          onTap: () {
                            gotoEditProduct(index, item);
                          },
                        ),
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                          ),
                          onTap: () {
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
                                            updateList();
                                          },
                                          child: const Text(
                                            AppStrings.yes,
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(AppStrings.no))
                                    ],
                                  );
                                });
                          },
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
