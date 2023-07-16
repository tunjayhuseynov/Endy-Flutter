import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/foundation.dart' as f;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class SearchPageState {
  final String search;
  List<Product> products = [];
  final int currentPage;
  final bool isLastPage;
  final bool isSearching;
  final int per_page;
  final bool isClosed;

  SearchPageState(
      {this.search = '',
      this.products = const [],
      this.currentPage = 1,
      this.isLastPage = false,
      this.isSearching = true,
      this.isClosed = false,
      this.per_page = f.kIsWeb ? 10 : 5});

  SearchPageState copyWith({
    String? search,
    List<Product>? products,
    int? currentPage,
    bool? isLastPage,
    bool? isSearching,
    int? per_page,
    bool? isClosed,
  }) {
    return SearchPageState(
      search: search ?? this.search,
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isSearching: isSearching ?? this.isSearching,
      per_page: per_page ?? this.per_page,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

class SearchPageBloc extends Cubit<SearchPageState> {
  SearchPageBloc() : super(SearchPageState());

  void setSearch(String search) {
    if (search == '')
      reset();
    else
      emit(state.copyWith(
          search: search, currentPage: 1, isLastPage: false, products: []));
  }

  void setClose() => emit(state.copyWith(isClosed: true));

  void setProducts(List<Product> products) =>
      emit(state.copyWith(products: products));

  void addProducts(List<Product> products) =>
      emit(state.copyWith(products: [...state.products, ...products]));

  void setCurrentPage(int currentPage) =>
      emit(state.copyWith(currentPage: currentPage));

  void setIsLastPage(bool islast) => emit(state.copyWith(isLastPage: islast));

  void setIsSearching(bool isSearching) =>
      emit(state.copyWith(isSearching: isSearching));

  void reset() => emit(SearchPageState());

  void set(SearchPageState state) => emit(state);

  Future<List<Product>> getSearchResult(String search, String? categoryId,
      String? companyId, String? subcategoryId, Client client,
      {int? per_page, int? current_page, bool? resetListOnEachRequest}) async {
    if (search == '') return [];
    if (state.isSearching == true && state.products.isNotEmpty) return [];
    if (state.isLastPage) {
      setIsSearching(false);
      return [];
    }

    setIsSearching(true);
    try {
      final rawHits = await ProductsCrud.getProductsFromTypesense(
        client,
        search,
        current_page: state.currentPage,
        per_page: state.per_page,
        categoryId: categoryId,
        companyId: companyId,
        subcategoryId: subcategoryId,
      );
      if (this.isClosed) return [];
      if (rawHits['hits'].length == 0) {
        emit(state.copyWith(isLastPage: true, isSearching: false));
        return [];
      }

      List<Product> hits = rawHits['hits']
          .map<Product>((e) => Product.fromJson(e["document"]))
          .toList();
      emit(state.copyWith(
        products: resetListOnEachRequest == true
            ? hits
            : [...state.products, ...hits],
        currentPage: state.currentPage + 1,
        isSearching: false,
        isLastPage:
            (rawHits['out_of'] / state.per_page).ceil() == state.currentPage,
      ));

      return hits;
    } catch (e) {
      setIsSearching(false);
      print(e);
      throw Exception(e);
    }
  }
}
