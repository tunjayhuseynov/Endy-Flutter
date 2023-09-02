import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/model/productFetch.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/model/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class CategoryFetchState {
  int per_page;
  CategoryFetchState({
    this.per_page = kIsWeb ? 15 : 6,
  });

  CategoryFetchState copyWith({
    int? per_page,
  }) {
    return CategoryFetchState(
      per_page: per_page ?? this.per_page,
    );
  }
}

class CategoryFetchBloc extends Cubit<CategoryFetchState> {
  CategoryFetchBloc() : super(CategoryFetchState());

  void setState(CategoryFetchState state) {
    emit(state);
  }


  static Future<ProductFetch> fetch({
    required BuildContext context,
    required Client client,
    required int currentPage,
    String? categoryId,
    String? companyId,
    required FilterPageState filter,
    String? subcategoryId,
  }) async {
    return await context.read<CategoryFetchBloc>().getResult(
        categoryId, companyId, subcategoryId, client,
        mode: filter, currentPage: currentPage);
  }

  Future<ProductFetch> getResult(String? categoryId, String? companyId,
      String? subcategoryId, Client client,
      {FilterPageState mode = FilterPageState.none,
      required int currentPage}) async {
    try {
      final rawHits = await ProductsCrud.getProductsFromTypesense(client, "",
          current_page: currentPage,
          per_page: state.per_page,
          categoryId: categoryId,
          companyId: companyId,
          subcategoryId: subcategoryId,
          mode: mode);

      List<Product> hits = (await Future.wait(rawHits['hits']
          .map<Future<Product>>(
              (e) => ProductsCrud.renderProduct(e["document"]))));

      if (this.isClosed) return ProductFetch(products: [], isLastPage: false);
 
      return ProductFetch(
          products: hits, isLastPage: ((rawHits['out_of'] as num) / state.per_page.toDouble()).ceil() == currentPage);
    } catch (e) {
      throw Exception(e);
    }
  }
}
