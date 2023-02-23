// ignore_for_file: file_names

import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyLabelListState {
  final String searchValue;

  List<Category> categories;


  CompanyLabelListState({
    this.searchValue = "",
    this.categories = const [],
  });

  CompanyLabelListState copyWith({
    String? searchValue,
    List<Category>? categories,
    List<dynamic>? subcategories,
    List<Company>? companies,
  }) {
    return CompanyLabelListState(
      searchValue: searchValue ?? this.searchValue,
      categories: categories ?? this.categories,
    );
  }

  List<Object?> get props => [
        searchValue,
        // categories,
      ];
}

class CompanyLabelListBloc extends Cubit<CompanyLabelListState> {
  CompanyLabelListBloc() : super(CompanyLabelListState());

  void search(String value) {
    emit(state.copyWith(searchValue: value));
  }

}
