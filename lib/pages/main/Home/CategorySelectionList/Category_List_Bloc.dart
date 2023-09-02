// ignore_for_file: file_names

import 'package:endy/model/category.dart';
import 'package:endy/model/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListState {
  final String searchValue;

  List<Category> categories;

  Category? selectedCategory;

  CategoryListState({
    this.searchValue = "",
    this.categories = const [],
    this.selectedCategory,
  });

  CategoryListState copyWith({
    String? searchValue,
    List<Category>? categories,
    List<dynamic>? subcategories,
    List<Company>? companies,
    Category? selectedCategory,
  }) {
    return CategoryListState(
      searchValue: searchValue ?? this.searchValue,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  List<Object?> get props => [
        searchValue,
        // categories,
        selectedCategory,
      ];
}

class CategoryListBloc extends Cubit<CategoryListState> {
  CategoryListBloc() : super(CategoryListState());

  void search(String value) {
    emit(state.copyWith(searchValue: value));
  }

  void setTypeAndList(
    Category selectedCategory, 
    // List<Category> categories
    ) {
    emit(state.copyWith(
      selectedCategory: selectedCategory,
      // categories: categories,
    ));
  }
}
