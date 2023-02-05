import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
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
      this.per_page = f.kIsWeb ? 32 : 5});

  SearchPageState copyWith({
    String? search,
    List<Product>? products = const [],
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
    emit(state.copyWith(
        search: search,
        currentPage: 1,
        isLastPage: false,
        products: [],
        isSearching: true));
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

  Future<List<Product>> getSearchResult(Category? category, Company? company,
      Subcategory? subcategory, Client client) async {
    if (state.search == '') return [];
    String q = state.search;
    String sort = "deadline:asc";
    String filter = 'status:=approved';

    if (state.isLastPage) {
      setIsSearching(false);
      return [];
    }

    if (category != null) {
      if (filter.isNotEmpty) filter += '&&';
      filter += 'category:=categories/${category.id}';
    }
    if (company != null) {
      if (filter.isNotEmpty) filter += '&&';
      filter += 'company:=companies/${company.id}';
    }
    if (subcategory != null) {
      if (filter.isNotEmpty) filter += '&&';
      filter += 'subcategory:=subcategories/${subcategory.id}';
    }

    try {
      final rawHits = await client.collection("products").documents.search({
        "q": q,
        "query_by": "name,description",
        "sort_by": sort,
        "filter_by": filter,
        "page": state.currentPage.toString(),
        "per_page": state.per_page.toString(),
      });

      if (rawHits['hits'].length == 0) {
        emit(
            state.copyWith(isLastPage: true, isSearching: false, products: []));
        return [];
      }

      List<Product> hits = rawHits['hits']
          .map<Product>((e) => Product.fromJson(e["document"]))
          .toList();
      emit(state.copyWith(
        products: [...state.products, ...hits],
        currentPage: state.currentPage + 1,
        isSearching: false,
        isLastPage:
            (rawHits['found'] / state.per_page).ceil() == state.currentPage,
      ));

      return hits;
    } catch (e) {
      throw Exception(e);
    }
  }
}
