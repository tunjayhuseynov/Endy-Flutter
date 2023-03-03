import 'package:async/async.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
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
  int currentPage;
  int per_page;
  bool isSearching;
  CancelableOperation<List<Product>>? cancellableOperation;

  CategoryFetchState({
    this.isLastPage = false,
    this.products = const [],
    this.currentPage = 1,
    this.per_page = kIsWeb ? 15 : 5,
    this.isSearching = true,
    this.cancellableOperation,
  });

  CategoryFetchState copyWith({
    List<Product>? products,
    bool? isLastPage,
    int? currentPage,
    int? per_page,
    bool? isSearching,
    CancelableOperation<List<Product>>? cancellableOperation,
  }) {
    return CategoryFetchState(
      products: products ?? this.products,
      isLastPage: isLastPage ?? this.isLastPage,
      currentPage: currentPage ?? this.currentPage,
      per_page: per_page ?? this.per_page,
      isSearching: isSearching ?? this.isSearching,
      cancellableOperation: cancellableOperation ?? this.cancellableOperation,
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
        currentPage: 1, isLastPage: false, products: [], isSearching: true));
  }

  void reset({bool? isSearch}) =>
      emit(CategoryFetchState(isSearching: isSearch ?? true));

  void setSearching(bool isSearching) =>
      emit(state.copyWith(isSearching: isSearching));

  void setCancelableoperation(
      CancelableOperation<List<Product>>? cancellableOperation) {
    state.cancellableOperation = cancellableOperation;
  }

  static fetch(BuildContext context, Client client, String? categoryId,
      String? companyId, String? subcategoryId,
      {bool? resetProduct}) {
    var ctx = context.read<CategoryFetchBloc>();
    var filterState = context.read<FilterPageBloc>().state;
    if (ctx.state.cancellableOperation != null) {
      ctx.state.cancellableOperation!.cancel();
    }
    if (resetProduct == true) {
      ctx.reset();
    }
    var c = CancelableOperation.fromFuture(context
        .read<CategoryFetchBloc>()
        .getResult(categoryId, companyId, subcategoryId, client,
            mode: filterState, resetProduct: resetProduct));
    ctx.setCancelableoperation(c);
  }

  Future<List<Product>> getResult(String? categoryId, String? companyId,
      String? subcategoryId, Client client,
      {FilterPageState mode = FilterPageState.none, bool? resetProduct}) async {
    if (state.isLastPage) {
      setSearching(false);
      return [];
    }
    if (state.isSearching == true && state.products.isNotEmpty) return [];

    setSearching(true);

    try {
      final rawHits = await ProductsCrud.getProductsFromTypesense(
          client, "", state.currentPage, state.per_page,
          categoryId: categoryId,
          companyId: companyId,
          subcategoryId: subcategoryId,
          mode: mode);

      List<Product> hits = (await Future.wait(rawHits['hits']
          .map<Future<Product>>(
              (e) => ProductsCrud.renderProduct(e["document"]))));

      setState(state.copyWith(
        products: [...state.products, ...hits],
        currentPage: state.currentPage + 1,
        isSearching: false,
        isLastPage:
            (rawHits['found'] / state.per_page).ceil() == state.currentPage + 1,
      ));

      return hits;
    } catch (e) {
      setSearching(false);
      throw Exception(e);
    }
  }
}
