import 'package:endy/types/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryGridBarState {

  double searchWidth;
  bool suffixMode;
  bool isClosing;
  bool title;

  List<Product> paginationList;

  CategoryGridBarState({
    this.searchWidth = 80,
    this.paginationList = const [],
    this.suffixMode = false,
    this.isClosing = true,
    this.title = true,
  });

  CategoryGridBarState copyWith({
    List<Product>? paginationList,
    double? searchWidth,
    bool? suffixMode,
    bool? isClosing,
    bool? title,
  }) {
    return CategoryGridBarState(
      searchWidth: searchWidth ?? this.searchWidth,
      paginationList: paginationList ?? this.paginationList,
      suffixMode: suffixMode ?? this.suffixMode,
      isClosing: isClosing ?? this.isClosing,
      title: title ?? this.title,
    );
  }
}

class CategoryGridBarBloc extends Cubit<CategoryGridBarState> {
  CategoryGridBarBloc() : super(CategoryGridBarState());

  void set({double? width, bool? suffixMode, bool? isClosing}) {
    emit(state.copyWith(
      searchWidth: width ?? state.searchWidth,
      suffixMode: suffixMode ?? state.suffixMode,
      isClosing: isClosing ?? state.isClosing,
    ));
  }

  void deleteCache() {
    emit(CategoryGridBarState());
  }

  void addPaginationList(List<Product> list) {
    emit(state.copyWith(
      paginationList: [...state.paginationList, ...list],
    ));
  }

  void changeTitleStatus(bool status) {
    emit(state.copyWith(
      title: status,
    ));
  }

  void deletePaginationList() {
    emit(state.copyWith(
      paginationList: [],
    ));
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
