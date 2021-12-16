import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sequoia_capital_assignment/config/app_colors.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/config/routes.dart';
import 'package:sequoia_capital_assignment/extensions.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';

import '../enums/product_sortby_type.dart';
import '../models/product_model.dart';
import '../utils/app_widgets.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productList = useState(Provider.of<List<ProductModel>>(context));
    final selectedSortType = useState(ProductSortByType.name);
    final selectedSortOrderIsAsc = useState(true);
    final isGridViewSelected = useState(false);

    var sortTypeText = "";
    if (selectedSortType.value == ProductSortByType.name) {
      sortTypeText = AppStrings.name;
    } else if (selectedSortType.value == ProductSortByType.site) {
      sortTypeText = AppStrings.launchedSite;
    } else if (selectedSortType.value == ProductSortByType.date) {
      sortTypeText = AppStrings.launchedAt;
    } else {
      sortTypeText = AppStrings.rating;
    }

    void updateList() {
      productList.value = List.from(productList.value);
    }

    Future<void> gotoAddProduct() async {
      dynamic result = await Navigator.pushNamed(
        context,
        AppRoutes.addProduct,
      );
      if (result != null) {
        productList.value.add(result['productModel']);
        updateList();
      }
    }

    void removeItemFromList(int index) {
      productList.value.removeAt(index);
      updateList();
    }

    Future<void> gotoEditProduct(int index, ProductModel productModel) async {
      dynamic result = await Navigator.pushNamed(
        context,
        AppRoutes.addProduct,
        arguments: {'updatingIndex': index, 'productModel': productModel},
      );
      if (result != null) {
        productList.value
            .update(result['updatingIndex'], result['productModel']);
        updateList();
      }
    }

    void _modalBottomSheetMenu(Function(ProductSortByType) onSortSelected) {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: const Text(
                      AppStrings.sortBy,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Text(
                        AppStrings.name,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      onSortSelected.call(ProductSortByType.name);
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Text(
                        AppStrings.launchedAt,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      onSortSelected.call(ProductSortByType.date);
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Text(
                        AppStrings.launchedSite,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      onSortSelected.call(ProductSortByType.site);
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Text(
                        AppStrings.rating,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      onSortSelected.call(ProductSortByType.ratings);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    }

    /// sort logic ///
    if (productList.value.isNotEmpty) {
      switch (selectedSortType.value) {
        case ProductSortByType.name:
          productList.value = productList.value
              .sortedBy((e) => e.name, selectedSortOrderIsAsc.value)
              .toList();
          break;
        case ProductSortByType.date:
          productList.value = productList.value
              .sortedBy((e) => e.launchedAt, selectedSortOrderIsAsc.value)
              .toList();
          break;
        case ProductSortByType.site:
          productList.value = productList.value
              .sortedBy((e) => e.launchedAt, selectedSortOrderIsAsc.value)
              .toList();
          break;
        case ProductSortByType.ratings:
          productList.value = productList.value
              .sortedBy((e) => e.popularity, selectedSortOrderIsAsc.value)
              .toList();
          break;
      }
    }

    ///     ***    ///

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          Visibility(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                  onPressed: () {
                    isGridViewSelected.value = !isGridViewSelected.value;
                  },
                  child: Text(
                    isGridViewSelected.value
                        ? AppStrings.listView
                        : AppStrings.gridView,
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.2)),
                  )),
            ),
            visible: kIsWeb,
          ),
          Container(
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
                        Colors.white.withOpacity(0.2)))),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isGridViewSelected.value
          ? _GridPageData(productList, (index) {
              removeItemFromList(index);
            }, (product, index) {
              gotoEditProduct(index, product);
            })
          : _ListPageData(productList, (index) {
              removeItemFromList(index);
            }, (product, index) {
              gotoEditProduct(index, product);
            }),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (!productList.value.canSort()) {
                  return;
                }
                _modalBottomSheetMenu((value) {
                  selectedSortType.value = value;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(sortTypeText),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (!productList.value.canSort()) {
                    return;
                  }
                  selectedSortOrderIsAsc.value = !selectedSortOrderIsAsc.value;
                },
                icon: ImageIcon(
                  AssetImage(selectedSortOrderIsAsc.value
                      ? 'assets/ascending_icon.png'
                      : 'assets/descending_icon.png'),
                ))
          ],
        ),
      ],
    );
  }
}

class _GridPageData extends HookWidget {
  final Function(int) removeProduct;
  final Function(ProductModel, int) editProduct;
  final ValueNotifier<List<ProductModel>> productList;

  const _GridPageData(this.productList, this.removeProduct, this.editProduct,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 175,
      ),
      shrinkWrap: true,
      itemCount: productList.value.length,
      itemBuilder: (BuildContext context, int index) {
        var item = productList.value[index];
        return Card(
          color: AppColors.dashboardCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 10,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
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
                    EditIcon(onTap: () => editProduct.call(item, index)),
                    DeleteIcon(
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(AppStrings.deleteItem),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        removeProduct.call(index);
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
                            })
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ListPageData extends HookWidget {
  final ValueNotifier<List<ProductModel>> productList;
  final Function(int) removeProduct;
  final Function(ProductModel, int) editProduct;

  const _ListPageData(this.productList, this.removeProduct, this.editProduct,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                    color: AppColors.dashboardCardColor,
                    borderRadius: BorderRadius.circular(8)),
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
                        EditIcon(onTap: () => editProduct.call(item, index)),
                        DeleteIcon(
                          onTap: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(AppStrings.deleteItem),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            removeProduct.call(index);
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
                                })
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
