import 'dart:ffi';

import 'package:endy/providers/FilterChange.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/cupertino.dart';

class CacheChange extends ChangeNotifier {
  List<List<Product>> mainPageProducts = [];
  List<Product> mostViewedProducts = [];

  // void resetMainPage() {
  //   mainPageProducts = [];
  //   mostViewedProducts = [];
  //   notifyListeners();
  // }

  // Future<List<List<Product>>> getMainPageProductWithCache(
  //     List<Category> categories, FilterChange filter) async {
  //   if (mainPageProducts.isNotEmpty) {
  //     return Future.value(mainPageProducts);
  //   } else {
  //     var values = await Future.wait(categories.map((e) =>
  //         ProductsCrud.getProducts(null, 4, e, null, filter.mode, null)));
  //     mainPageProducts.addAll(values);
  //     return values;
  //   }
  // }

  // Future<List<Product>> getMainPageMostViewedProductWithCache() async {
  //   if (mostViewedProducts.isNotEmpty) {
  //     return Future.value(mostViewedProducts);
  //   } else {
  //     var values = await ProductsCrud.getMostViewedProducts();
  //     mostViewedProducts.addAll(values);
  //     return values;
  //   }
  // }
}
