import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryGridCacheAndBarState {
  List<Product> cachedProducts;

  double searchWidth;
  bool suffixMode;
  bool isClosing;

  CategoryGridCacheAndBarState({
    this.cachedProducts = const [],
    this.searchWidth = 80,
    this.suffixMode = false,
    this.isClosing = true,
  });

  CategoryGridCacheAndBarState copyWith({
    List<Product>? cachedProducts,
    double? searchWidth,
    bool? suffixMode,
    bool? isClosing,
  }) {
    return CategoryGridCacheAndBarState(
      cachedProducts: cachedProducts ?? this.cachedProducts,
      searchWidth: searchWidth ?? this.searchWidth,
      suffixMode: suffixMode ?? this.suffixMode,
      isClosing: isClosing ?? this.isClosing,
    );
  }
}

class CategoryGridCacheBloc extends Cubit<CategoryGridCacheAndBarState> {
  CategoryGridCacheBloc() : super(CategoryGridCacheAndBarState());

  Future<List<Product>> getProducts(
      Category? category,
      Subcategory? subcategory,
      FilterPageState? filterState,
      Company? company,
      String? text) async {
    if (state.cachedProducts.isNotEmpty) {
      return state.cachedProducts;
    }
    var data = await ProductsCrud.getProducts(
        null, null, category, subcategory, filterState, company, text);
    // emit(state.copyWith(cachedProducts: data));
    return data;
  }

  void set({double? width, bool? suffixMode, bool? isClosing}) {
    emit(state.copyWith(
      searchWidth: width ?? state.searchWidth,
      suffixMode: suffixMode ?? state.suffixMode,
      isClosing: isClosing ?? state.isClosing,
    ));
  }

  void deleteCache() {
    emit(CategoryGridCacheAndBarState());
  }

  void setSearchWidth(double width) {
    emit(state.copyWith(
      searchWidth: width,
    ));
  }

  void setSuffixMode(bool mode) {
    emit(state.copyWith(
      suffixMode: mode,
    ));
  }

  void setIsClosing(bool isClosing) {
    emit(state.copyWith(
      isClosing: isClosing,
    ));
  }
}
