import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryGridState {
  String selectedId;
  String prevPath;

  int reset = 0;

  // Subcategory? subcategory;
  // Company? company;
  // Category? category;

  CategoryGridState({
    this.selectedId = "",
    this.reset = 0,
    this.prevPath = "",
    // this.subcategory,
    // this.company,
    // this.category
  });

  CategoryGridState copyWith({
    String? selectedId,
    int? reset,
    Subcategory? subcategory,
    String? prevPath,
    Company? company,
    Category? category,
  }) {
    return CategoryGridState(
      selectedId: selectedId ?? this.selectedId,
      prevPath: prevPath ?? this.prevPath,
      // subcategory: subcategory,
      // company: company,
      // category: category,
      reset: reset ?? this.reset,
    );
  }
}

class CategoryGridBloc extends Cubit<CategoryGridState> {
  CategoryGridBloc() : super(CategoryGridState());

  void set(
      {String? id,
      Company? company,
      String? prevPath,
      Category? category,
      Subcategory? subcategory}) {
    emit(state.copyWith(
      selectedId: id,
      prevPath: prevPath,
      company: company,
      category: category,
      subcategory: subcategory,
    ));
  }

  void setSelectedId(String id) {
    emit(state.copyWith(
      selectedId: id,
      // subcategory: state.subcategory,
      // company: state.company,
      // category: state.category
    ));
  }

  void setCompany(Company? company) {
    emit(state.copyWith(
      company: company,
      // category: state.category,
      // subcategory: state.subcategory
    ));
  }

  void setCategory(Category? category) {
    emit(state.copyWith(
      category: category,
      // subcategory: state.subcategory,
      // company: state.company
    ));
  }

  void setSubcategory(Subcategory? subcategory) {
    emit(state.copyWith(
      subcategory: subcategory,
      // category: state.category,
      // company: state.company
    ));
  }

  void resetAll() {
    emit(state.copyWith(
      reset: state.reset + 1,
      // company: state.company,
      // category: state.category,
      // subcategory: state.subcategory
    ));
  }
}
