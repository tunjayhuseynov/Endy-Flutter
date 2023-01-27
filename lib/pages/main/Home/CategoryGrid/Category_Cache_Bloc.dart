import 'package:async/async.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class CategoryCacheState {
  List<Product> products;
  bool isLastPage;
  int currentPage;
  int per_page;
  bool isSearching;
  bool isClosed;
  CancelableOperation<CategoryCacheState?>? cancellableOperation;

  CategoryCacheState({
    this.isLastPage = false,
    this.products = const [],
    this.currentPage = 1,
    this.per_page = 5,
    this.isSearching = true,
    this.isClosed = false,
    this.cancellableOperation,
  });

  CategoryCacheState copyWith({
    List<Product>? products,
    bool? isLastPage,
    int? currentPage,
    int? per_page,
    bool? isSearching,
    bool? isClosed,
    CancelableOperation<CategoryCacheState?>? cancellableOperation,
  }) {
    return CategoryCacheState(
      products: products ?? this.products,
      isLastPage: isLastPage ?? this.isLastPage,
      currentPage: currentPage ?? this.currentPage,
      per_page: per_page ?? this.per_page,
      isSearching: isSearching ?? this.isSearching,
      isClosed: isClosed ?? this.isClosed,
      cancellableOperation: cancellableOperation ?? this.cancellableOperation,
    );
  }
}

class CategoryCacheBloc extends Cubit<CategoryCacheState> {
  CategoryCacheBloc() : super(CategoryCacheState());

  @override
  Future<void> close() async {
    emit(state.copyWith(isClosed: true));
    return super.close();
  }

  void setState(CategoryCacheState state) {
    emit(state);
  }

  void set() {
    emit(state.copyWith(
        currentPage: 1, isLastPage: false, products: [], isSearching: true));
  }

  void reset() => emit(CategoryCacheState());

  void setClose() => emit(state.copyWith(isClosed: true));

  void setSearching(bool isSearching) =>
      emit(state.copyWith(isSearching: isSearching));

  void setCancelableoperation(
      CancelableOperation<CategoryCacheState?>? cancellableOperation) {
    emit(state.copyWith(cancellableOperation: cancellableOperation));
  }

  Future<CategoryCacheState?> getResult(
    Category? category,
    Company? company,
    Subcategory? subcategory,
    Client client, {
    FilterPageState mode = FilterPageState.none,
  }) async {
    String q = "";
    String sort = "deadline:asc";
    String filter = 'status:=approved';

    if (state.isLastPage) {
      setSearching(false);
      return null;
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

    if (mode == FilterPageState.moreThan20) {
      if (filter.isNotEmpty) filter += '&&';
      filter += 'discount:>20';
    }

    if (mode == FilterPageState.lastDay) {
      if (filter.isNotEmpty) filter += '&&';
      DateTime now = DateTime.now();
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      filter += 'deadline:<${(endOfDay.millisecondsSinceEpoch / 1000).round()}';
    }

    if (mode == FilterPageState.lastAdded) {
      sort = 'created_at:desc';
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

      if (isClosed) return null;

      List<Product> hits = (await Future.wait(rawHits['hits']
          .map<Future<Product>>(
              (e) => ProductsCrud.renderProduct(e["document"]))));

      return state.copyWith(
        products: [...state.products, ...hits],
        currentPage: state.currentPage + 1,
        isSearching: false,
        isLastPage:
            (rawHits['found'] / state.per_page).ceil() == state.currentPage,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
