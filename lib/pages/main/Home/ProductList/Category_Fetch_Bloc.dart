import 'package:async/async.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class CategoryFetchState {
  List<Product> products;
  bool isLastPage;
  int nextPage;
  int per_page;
  bool isSearching;

  CategoryFetchState({
    this.isLastPage = false,
    this.products = const [],
    this.nextPage = 1,
    this.per_page = kIsWeb ? 15 : 6,
    this.isSearching = true,
  });

  CategoryFetchState copyWith({
    List<Product>? products,
    bool? isLastPage,
    int? nextPage,
    int? per_page,
    bool? isSearching,
    CancelableOperation<List<Product>>? cancellableOperation,
  }) {
    return CategoryFetchState(
      products: products ?? this.products,
      isLastPage: isLastPage ?? this.isLastPage,
      nextPage: nextPage ?? this.nextPage,
      per_page: per_page ?? this.per_page,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class CategoryFetchBloc extends Cubit<CategoryFetchState> {
  CategoryFetchBloc() : super(CategoryFetchState());

  void setState(CategoryFetchState state) {
    emit(state);
  }

  void set() {
    emit(state.copyWith(
        nextPage: 1, isLastPage: false, products: [], isSearching: true));
  }

  void reset({bool? isSearch}) =>
      emit(CategoryFetchState(isSearching: isSearch ?? true));

  void setSearching(bool isSearching) =>
      emit(state.copyWith(isSearching: isSearching));

  static Future<void> fetch(
      {required BuildContext context,
      required Client client,
      String? categoryId,
      String? companyId,
      String? subcategoryId,
      bool? resetProduct}) async {
    var ctx = context.read<CategoryFetchBloc>();
    var filterState = context.read<FilterPageBloc>().state;

    if (resetProduct == true) {
      ctx.reset();
    }
    await context.read<CategoryFetchBloc>().getResult(
        categoryId, companyId, subcategoryId, client,
        mode: filterState, resetProduct: resetProduct);
  }

  Future<List<Product>> getResult(String? categoryId, String? companyId,
      String? subcategoryId, Client client,
      {FilterPageState mode = FilterPageState.none, bool? resetProduct}) async {
    print(state.isLastPage);
    if (state.isLastPage) {
      setSearching(false);
      return [];
    }
    if (state.isSearching == true && state.products.isNotEmpty) return [];

    setSearching(true);

    try {
      final rawHits = await ProductsCrud.getProductsFromTypesense(client, "",
          current_page: resetProduct == true ? 1 : state.nextPage,
          per_page: state.per_page,
          categoryId: categoryId,
          companyId: companyId,
          subcategoryId: subcategoryId,
          mode: mode);

      List<Product> hits = (await Future.wait(rawHits['hits']
          .map<Future<Product>>(
              (e) => ProductsCrud.renderProduct(e["document"]))));

      if (this.isClosed) return [];

      setState(state.copyWith(
        products: resetProduct == true ? hits : [...state.products, ...hits],
        nextPage: resetProduct == true ? 2 : state.nextPage + 1,
        isSearching: false,
        isLastPage:
            (rawHits['out_of'] / state.per_page).ceil() == state.nextPage + 1,
      ));

      return hits;
    } catch (e) {
      setSearching(false);
      throw Exception(e);
    }
  }
}
