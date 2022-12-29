import 'package:endy/pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
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

  HomePageCacheState({
    this.products = const [],
    this.mostViewedProducts = const [],
  });

  HomePageCacheState copyWith({
    List<List<Product>>? products,
    List<Product>? mostViewedProducts,
  }) {
    return HomePageCacheState(
      products: products ?? this.products,
      mostViewedProducts: mostViewedProducts ?? this.mostViewedProducts,
    );
  }
}

class HomePageCacheBloc extends Cubit<HomePageCacheState> {
  HomePageCacheBloc() : super(HomePageCacheState());

  void deleteCache() {
    emit(HomePageCacheState());
  }

  Future<List<List<Product>>> getProducts(
      List<Category> categories, FilterPageState filterState) {
    if (state.products.isNotEmpty) return Future.value(state.products);
    var data = Future.wait(categories.map(
        (e) => ProductsCrud.getProducts(null, 4, e, null, filterState, null)));
    data.then((value) => emit(state.copyWith(products: value)));
    return data;
  }

  Future<List<Product>> getMostViewedProducts(
      List<Category> categories, FilterPageState filterState) {
    if (state.mostViewedProducts.isNotEmpty) {
      return Future.value(state.mostViewedProducts);
    }
    var values = ProductsCrud.getMostViewedProducts();
    values.then((value) => emit(state.copyWith(mostViewedProducts: value)));
    return values;
  }
}
