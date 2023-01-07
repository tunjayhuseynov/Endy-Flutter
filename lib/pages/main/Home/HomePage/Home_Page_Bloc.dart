import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageNavBloc extends Cubit<int> {
  HomePageNavBloc() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void setIndex(int index) => emit(index);
}

class HomePageCacheState {
  final List<List<Product>> products;
  final List<Product> mostViewedProducts;
  final bool isClosed;

  HomePageCacheState({
    this.products = const [],
    this.isClosed = false,
    this.mostViewedProducts = const [],
  });

  HomePageCacheState copyWith({
    List<List<Product>>? products,
    List<Product>? mostViewedProducts,
    bool? isClosed,
  }) {
    return HomePageCacheState(
      products: products ?? this.products,
      mostViewedProducts: mostViewedProducts ?? this.mostViewedProducts,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

class HomePageCacheBloc extends Cubit<HomePageCacheState> {
  HomePageCacheBloc() : super(HomePageCacheState());

  void deleteCache() {
    emit(HomePageCacheState());
  }

  void setClose() => emit(state.copyWith(isClosed: true));

  Future<List<List<Product>>> getProducts(
      List<Category> categories, FilterPageState filterState) async {
    if (state.products.isNotEmpty) return Future.value(state.products);
    var data = await Future.wait(categories.map(
        (e) => ProductsCrud.getProducts(null, 4, e, null, filterState, null)));
    if (state.isClosed) return Future.value([]);
    emit(state.copyWith(products: data));
    return data;
  }

  Future<List<Product>> getMostViewedProducts(
      List<Category> categories, FilterPageState filterState) async {
    if (state.mostViewedProducts.isNotEmpty) {
      return Future.value(state.mostViewedProducts);
    }
    var values = await ProductsCrud.getMostViewedProducts();
    if (state.isClosed) return Future.value([]);
    emit(state.copyWith(mostViewedProducts: values));
    return values;
  }
}
