import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/model/category.dart';
import 'package:endy/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageNavBloc extends Cubit<int> {
  HomePageNavBloc() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void setIndex(int index) => emit(index);
}

enum ConnectionStatus {
  Loading,
  Connected,
  Disconnected,
}

class HomePageCacheState {
  final List<List<Product>> products;
  final List<Product> mostViewedProducts;
  final bool isClosed;
  final ConnectionStatus mainProductsConnectionStatus;
  final ConnectionStatus mostViewedConnectionStatus;

  HomePageCacheState({
    this.products = const [],
    this.isClosed = false,
    this.mostViewedProducts = const [],
    this.mainProductsConnectionStatus = ConnectionStatus.Loading,
    this.mostViewedConnectionStatus = ConnectionStatus.Loading,
  });

  HomePageCacheState copyWith({
    List<List<Product>>? products,
    List<Product>? mostViewedProducts,
    bool? isClosed,
    ConnectionStatus? mainProductsConnectionStatus,
    ConnectionStatus? mostViewedConnectionStatus,
  }) {
    return HomePageCacheState(
      products: products ?? this.products,
      mostViewedProducts: mostViewedProducts ?? this.mostViewedProducts,
      isClosed: isClosed ?? this.isClosed,
      mainProductsConnectionStatus:
          mainProductsConnectionStatus ?? this.mainProductsConnectionStatus,
      mostViewedConnectionStatus:
          mostViewedConnectionStatus ?? this.mostViewedConnectionStatus,
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
      List<Category> categories, FilterPageState filterState,
      {int limit = 4}) async {
    if (state.products.isNotEmpty) return state.products;
    var data = await Future.wait(categories.map((e) =>
        ProductsCrud.getProducts(null, limit, e, null, filterState, null)));
    var response = data.where((element) => element.length > 0).toList();
    emit(state.copyWith(products: response));
    return response;
  }

  Future<List<Product>> getMostViewedProducts(
      List<Category> categories, FilterPageState filterState) async {
    if (state.mostViewedProducts.isNotEmpty) {
      return Future.value(state.mostViewedProducts);
    }
    var values = await ProductsCrud.getMostViewedProducts();
    if (state.isClosed) return Future.value([]);
    emit(state.copyWith(
        mostViewedProducts: values,
        mostViewedConnectionStatus: ConnectionStatus.Connected));
    return values;
  }
}
