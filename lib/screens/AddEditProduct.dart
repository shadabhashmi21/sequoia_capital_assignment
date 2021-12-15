import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';

class AddEditProduct extends HookWidget {
  final ProductModel? productModel;
  final int? updateIndex;

  const AddEditProduct({Key? key, this.productModel, this.updateIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController launchedAtController = TextEditingController();
    TextEditingController launchSiteController = TextEditingController();

    nameController.text = productModel?.name ?? "";
    launchedAtController.text = productModel?.launchedAt ?? "";
    launchSiteController.text = productModel?.launchSite ?? "";
    double rating = productModel?.popularity ?? 0;

    void saveData() {
      /// todo - add field validations
      final newProductModel = ProductModel(nameController.text, launchedAtController.text, launchSiteController.text, rating);
      Navigator.pop(context, {'updatingIndex': updateIndex, 'productModel': newProductModel});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(productModel == null
            ? AppStrings.addProduct
            : AppStrings.editProduct),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppStrings.name,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                      controller: launchedAtController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppStrings.launchedAt,
                      )),
                ),
                TextField(
                    controller: launchSiteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppStrings.launchedSite,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RatingBar.builder(
                    initialRating: rating,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 50,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    allowHalfRating: true,
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        saveData();
                      },
                      child: const Text(
                        AppStrings.save,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(20)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)))),
              Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppStrings.cancel,
                          style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(20)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)))),
            ],
          )
        ],
      ),
    );
  }
}
