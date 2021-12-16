import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sequoia_capital_assignment/config/app_colors.dart';
import 'package:sequoia_capital_assignment/config/app_strings.dart';
import 'package:sequoia_capital_assignment/models/product_model.dart';
import 'package:sequoia_capital_assignment/utils/app_utils.dart';

import '../utils/date_time_utils.dart';

class AddEditProduct extends HookWidget {
  final ProductModel? productModel;
  final int? updateIndex;

  const AddEditProduct({Key? key, this.productModel, this.updateIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<List<ProductModel>>(context);

    TextEditingController nameController = TextEditingController();
    TextEditingController launchedAtController = TextEditingController();
    TextEditingController launchSiteController = TextEditingController();

    nameController.text = productModel?.name ?? "";
    launchedAtController.text = productModel?.launchedAt ?? "";
    launchSiteController.text = productModel?.launchSite ?? "";
    double rating = productModel?.popularity ?? 0;

    bool validation() {
      if (nameController.text.isEmpty) {
        AppUtils.showToast(AppStrings.errorName);
        return false;
      }
      if (launchedAtController.text.isEmpty) {
        AppUtils.showToast(AppStrings.errorLaunchedAt);
        return false;
      }
      if (launchSiteController.text.isEmpty) {
        AppUtils.showToast(AppStrings.errorLaunchedSite);
        return false;
      }
      if (rating == 0) {
        AppUtils.showToast(AppStrings.errorRating);
        return false;
      }
      if (productModel == null &&
          productList.isNotEmpty &&
          productList
              .where((element) => element.name == nameController.text)
              .isNotEmpty) {
        AppUtils.showToast(AppStrings.errorDuplicateProduct);
        return false;
      }
      return true;
    }

    void saveData() {
      AppUtils.closeKeyboard(context);
      if (validation()) {
        final newProductModel = ProductModel(nameController.text,
            launchedAtController.text, launchSiteController.text, rating);
        Navigator.pop(context,
            {'updatingIndex': updateIndex, 'productModel': newProductModel});
      }
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
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppStrings.name,
                        fillColor: AppColors.forumBackgroundColor,
                        filled: true)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                      readOnly: true,
                      controller: launchedAtController,
                      onTap: () {
                        AppUtils.showDatePickerDialog(context, (dateTime) {
                          launchedAtController.text =
                              DateTimeUtils.convertDateTimeToString(
                                  dateTime, DateTimeUtils.dateFormatYYYYMMDD);
                        });
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppStrings.launchedAt,
                          fillColor: AppColors.forumBackgroundColor,
                          filled: true)),
                ),
                TextField(
                    controller: launchSiteController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppStrings.launchedSite,
                        fillColor: AppColors.forumBackgroundColor,
                        filled: true
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
