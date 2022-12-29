// ignore_for_file: file_names

import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelectionListState {
  final String searchValue;

  List<Category> categories;
  List<dynamic> subcategories;
  List<Company> companies;

  Category? selectedCategory;

  bool isSubcategory;
  bool isBrand;
  bool isAllCategories;

  CategorySelectionListState({
    this.searchValue = "",
    this.selectedCategory,
    this.isAllCategories = false,
    this.isBrand = false,
    this.isSubcategory = false,
    this.categories = const [],
    this.subcategories = const [],
    this.companies = const [],
  });

  CategorySelectionListState copyWith({
    String? searchValue,
    bool? isAllCategories,
    bool? isBrand,
    bool? isSubcategory,
    List<Category>? categories,
    List<dynamic>? subcategories,
    List<Company>? companies,
    Category? selectedCategory,
  }) {
    return CategorySelectionListState(
      searchValue: searchValue ?? this.searchValue,
      isAllCategories: isAllCategories ?? this.isAllCategories,
      isBrand: isBrand ?? this.isBrand,
      isSubcategory: isSubcategory ?? this.isSubcategory,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      companies: companies ?? this.companies,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  List<Object?> get props => [
        searchValue,
        isAllCategories,
        isBrand,
        isSubcategory,
        categories,
        subcategories,
        companies,
        selectedCategory,
      ];
}

class CategorySelectionListBloc extends Cubit<CategorySelectionListState> {
  CategorySelectionListBloc() : super(CategorySelectionListState());

  void search(String value) {
    emit(state.copyWith(searchValue: value));
  }

  void setTypeAndList(
      Category selectedCategory,
      bool isAllCategories,
      bool isCompany,
      bool isSubcategory,
      List<Category> categories,
      List<Company> companies,
      List<dynamic> subcategory) {
    emit(state.copyWith(
      selectedCategory: selectedCategory,
      isAllCategories: isAllCategories,
      isBrand: isCompany,
      isSubcategory: isSubcategory,
      categories: categories,
      companies: companies,
      subcategories: subcategory,
    ));
  }
}
