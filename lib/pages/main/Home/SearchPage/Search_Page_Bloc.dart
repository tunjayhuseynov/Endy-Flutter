import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPageState {
  final String search;
  final Category? category;
  final Subcategory? subcategory;
  final Company? company;

  SearchPageState(
      {this.category, this.subcategory, this.company, this.search = ''});

  SearchPageState copyWith(
      {String? search,
      Category? category,
      Subcategory? subcategory,
      Company? company}) {
    return SearchPageState(
      search: search ?? this.search,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      company: company ?? this.company,
    );
  }
}

class SearchPageBloc extends Cubit<SearchPageState> {
  SearchPageBloc() : super(SearchPageState());

  void setSearch(String search) => emit(state.copyWith(search: search));

  void setCategory(Category category) =>
      emit(state.copyWith(category: category));

  void setSubcategory(Subcategory subcategory) =>
      emit(state.copyWith(subcategory: subcategory));

  void setCompany(Company company) => emit(state.copyWith(company: company));
}
